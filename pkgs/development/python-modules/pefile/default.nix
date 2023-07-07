{ lib
, buildPythonPackage
, future
, fetchFromGitHub
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pefile";
  version = "2023.2.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "erocarrera";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-lD8GpNl+cVNYTZUKFRF1/2kDwEbn/ekRBNBTYuFmFW0=";
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
    changelog = "https://github.com/erocarrera/pefile/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
