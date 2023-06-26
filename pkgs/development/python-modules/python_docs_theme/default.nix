{ lib, buildPythonPackage, fetchFromGitHub, sphinx }:

buildPythonPackage rec {
  pname = "python_docs_theme";
  version = "2023.3.1";
  format = "flit";

  src = fetchFromGitHub {
    owner = "python";
    repo = "python-docs-theme";
    rev = version;
    sha256 = "sha256-WyO5Xc67k5ExB4eCFd17sZCBMaV5djle9BAM0tn5CPc=";
  };

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "python_docs_theme" ];

  meta = with lib; {
    homepage = "https://github.com/python/python-docs-theme";
    description = "Sphinx theme for CPython project";
    license = licenses.psfl;
    maintainers = with maintainers; [ kaction ];
  };
}
