{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  setuptools,
}:

let
  version = "v1.2.0";
in
buildPythonPackage {
  pname = "pyan3";
  pyproject = true;
  inherit version;

  src = fetchFromGitHub {
    owner = "Technologicat";
    repo = "pyan";
    tag = version;
    hash = "sha256-v+wszUOCib/8962dnNWwtD0saF9NsNSBQ154lovox4w=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ jinja2 ];

  pythonImportsCheck = [ "pyan" ];

  meta = {
    description = "Static call graph generator. The official Python 3 version.";
    homepage = "https://github.com/Technologicat/pyan";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ johnrichardrinehart ];
  };
}
