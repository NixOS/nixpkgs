{ lib
, callPackage
, buildPythonApplication
, fetchFromGitHub
, mkdocs
}:

buildPythonApplication rec {
  pname = "mkdocs-redirects";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-iJmNh81VVqaPWHL3d8u+hESlW3AhlCr/Ax9n5nOTd0o=";
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
