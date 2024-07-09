{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocs-redirects";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zv/tCsC2wrD0iH7Kvlq4nXJMPMGQ7+l68Y/q/x66LBg=";
  };

  propagatedBuildInputs = [ mkdocs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mkdocs_redirects" ];

  meta = with lib; {
    description = "Open source plugin for Mkdocs page redirects";
    homepage = "https://github.com/mkdocs/mkdocs-redirects";
    license = licenses.mit;
    maintainers = with maintainers; [ tfc ];
  };
}
