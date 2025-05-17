{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  mkdocs,
  mkdocs-material,
}:

buildPythonPackage rec {
  pname = "mkdocs-print-site-plugin";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timvink";
    repo = "mkdocs-print-site-plugin";
    rev = "v${version}";
    hash = "sha256-o0VOvm/KVTD7/1RQpLUSVZj8MdhFLSOh2y8gpmsM2KY=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    mkdocs
    mkdocs-material
  ];

  meta = with lib; {
    description = "MkDocs Plugin that adds an additional page that combines all pages, allowing easy exports to PDF and standalone HTML.";
    homepage = "https://timvink.github.io/mkdocs-print-site-plugin/";
    license = licenses.mit;
    maintainers = with maintainers; [ eliandoran ];
  };

}
