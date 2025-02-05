{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocs-redirects";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-YsMA00yajeGSqSB6CdKxGqyClC9Cgc3ImRBTucHEHhs=";
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
