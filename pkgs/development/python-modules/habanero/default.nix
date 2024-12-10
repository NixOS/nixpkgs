{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  requests,
  tqdm,
  vcrpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "habanero";
  version = "1.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sckott";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Pw0TgXxDRmR565hdNGipfDZ7P32pxWkmPWfaYK0RaI4=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    requests
    tqdm
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
