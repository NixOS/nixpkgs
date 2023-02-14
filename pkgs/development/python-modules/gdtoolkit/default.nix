{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, lark, docopt, pyyaml, setuptools, pythonRelaxDepsHook }:

buildPythonPackage rec {
  pname = "gdtoolkit";
  version = "3.3.1";

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRemoveDeps = [ "lark-parser" ];

  propagatedBuildInputs = [
    lark
    docopt
    pyyaml
    setuptools
  ];

  # If we try to get using fetchPypi it requires GeoIP (but the package dont has that dep!?)
  src = fetchFromGitHub {
    owner = "Scony";
    repo = "godot-gdscript-toolkit";
    rev = version;
    sha256 = "13nnpwy550jf5qnm9ixpxl1bwfnhhbiys8vqfd25g3aim4bm3gnn";
  };

  disabled = pythonOlder "3.7";

  # Tests cannot be run because they need network to install additional dependencies using pip and tox
  doCheck = false;
  pythonImportsCheck = [ "gdtoolkit" "gdtoolkit.formatter" "gdtoolkit.linter" "gdtoolkit.parser" ];

  meta = with lib; {
    description = "Independent set of tools for working with Godot's GDScript - parser, linter and formatter";
    homepage = "https://github.com/Scony/godot-gdscript-toolkit";
    license = licenses.mit;
    maintainers = with maintainers; [ shiryel ];
  };
}
