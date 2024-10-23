{
  lib,
  callPackage,
  buildPythonPackage,
  fetchPypi,
  mkdocs,
  jinja2,
  python-dateutil,
  termcolor,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "mkdocs-macros-plugin";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X9aWnixD4jAx/7cZvr50IRY+om9Nw2CvI0MUTKl5sEs=";
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
