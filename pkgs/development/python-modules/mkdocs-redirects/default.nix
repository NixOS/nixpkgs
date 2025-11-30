{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mkdocs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocs-redirects";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs-redirects";
    tag = "v${version}";
    hash = "sha256-YsMA00yajeGSqSB6CdKxGqyClC9Cgc3ImRBTucHEHhs=";
  };

  build-system = [ hatchling ];

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
