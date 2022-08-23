{ lib
, buildPythonPackage
, fetchFromGitHub
, docutils
, requests
, pytestCheckHook
, testpath
, responses
, flit-core
, tomli
, tomli-w
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
  version = "3.7.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "takluyver";
    repo = "flit";
    rev = version;
    sha256 = "sha256-zKgaeK3fskz2TuHvIWlxBrdZIWfIJHhaqopZ3+V36wY=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    docutils
    requests
    flit-core
    tomli
    tomli-w
  ];

  checkInputs = [ pytestCheckHook testpath responses ];

  disabledTests = [
    # needs some ini file.
    "test_invalid_classifier"
  ];

  meta = with lib; {
    description = "A simple packaging tool for simple packages";
    homepage = "https://github.com/pypa/flit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh SuperSandro2000 ];
  };
}
