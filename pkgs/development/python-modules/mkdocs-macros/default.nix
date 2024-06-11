{
  lib,
  callPackage,
  buildPythonPackage,
  fetchPypi,
  mkdocs,
  mkdocs-macros,
  mkdocs-material,
  jinja2,
  python-dateutil,
  termcolor,
  pyyaml,
  runCommand,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mkdocs-macros-plugin";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/jSNdfAckR82K22ZjFez2FtQWHbd5p25JPLFEsOVwyg=";
  };

  propagatedBuildInputs = [
    jinja2
    termcolor
    python-dateutil
    pyyaml
    mkdocs
  ];

  passthru.tests.example-doc = callPackage ./tests.nix { };

  pythonImportsCheck = [ "mkdocs_macros" ];

  meta = with lib; {
    homepage = "https://github.com/fralau/mkdocs_macros_plugin";
    description = "Create richer and more beautiful pages in MkDocs, by using variables and calls to macros in the markdown code";
    license = licenses.mit;
    maintainers = with maintainers; [ tljuniper ];
  };
}
