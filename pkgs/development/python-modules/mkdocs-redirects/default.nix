{ lib
, callPackage
, buildPythonApplication
, fetchFromGitHub
, mkdocs
}:

buildPythonApplication rec {
  pname = "mkdocs-redirects";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hdMfl8j+kZzePkSd/bBHKuVXAVA1sAt7DvPZj9x5i0c=";
  };

  propagatedBuildInputs = [
    mkdocs
  ];

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "Open source plugin for Mkdocs page redirects";
    homepage = "https://github.com/mkdocs/mkdocs-redirects";
    license = licenses.mit;
    maintainers = with maintainers; [ tfc ];
  };
}
