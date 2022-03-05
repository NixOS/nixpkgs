{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco-context";
  version = "4.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.context";
    rev = "v${version}";
    sha256 = "O9Lwv2d/qbiXxIVCp6FLmVKaz0MzAUkoUd0jAyIvgJc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonNamespaces = [
    "jaraco"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "jaraco.context" ];


  meta = with lib; {
    description = "Python module for context management";
    homepage = "https://github.com/jaraco/jaraco.context";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
