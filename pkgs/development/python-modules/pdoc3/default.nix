{ lib, buildPythonPackage, fetchPypi
, pythonOlder
, Mako
, markdown
, setuptools-git
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pdoc3";
  version = "0.9.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15482rvpg5r70gippj3nbl58x9plgmgvp0rg4xi4dpdqhma8v171";
  };

  nativeBuildInputs = [ setuptools-git setuptools_scm ];
  propagatedBuildInputs = [ Mako markdown ];

  meta = with lib; {
    description = "Auto-generate API documentation for Python projects.";
    homepage = "https://pdoc3.github.io/pdoc/";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ catern ];
  };
}
