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
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sckott";
    repo = "habanero";
    tag = "v${version}";
    hash = "sha256-XI+UOm3xONBNVSlywfBhnsCA9RdpEwDQ4oQixn4UBKk=";
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
  enabledTestPaths = [ "test/test-filters.py" ];

  meta = {
    description = "Python interface to Library Genesis";
    homepage = "https://habanero.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nico202 ];
  };
}
