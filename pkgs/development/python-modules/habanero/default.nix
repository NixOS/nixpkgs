{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  tqdm,
  urllib3,
  vcrpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "habanero";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sckott";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-GvrHCTmNEgqCiNzXPg7/L9QPd5FhSZBq3FA3qMBT0l4=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "urllib3" ];

  dependencies = [
    httpx
    tqdm
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [ "habanero" ];

  # almost the entirety of the test suite makes network calls
  pytestFlagsArray = [ "test/test-filters.py" ];

  meta = {
    description = "Python interface to Library Genesis";
    homepage = "https://habanero.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nico202 ];
  };
}
