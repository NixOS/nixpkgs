{ lib
, buildPythonPackage
, future
, fetchFromGitHub
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pefile";
  version = "2022.5.30";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "erocarrera";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Cv20hJsErHFSuS5Q1kqLNp4DAsPXv/eFhaU9oYECSeI=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    future
  ];

  # Test data encrypted
  doCheck = false;

  pythonImportsCheck = [
    "pefile"
  ];

  meta = with lib; {
    description = "Multi-platform Python module to parse and work with Portable Executable (aka PE) files";
    homepage = "https://github.com/erocarrera/pefile";
    license = licenses.mit;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
