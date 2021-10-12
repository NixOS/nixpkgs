{ lib, buildPythonPackage, fetchPypi
, pythonOlder
, Mako
, markdown
, setuptools-git
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pdoc3";
  version = "0.10.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f22e7bcb969006738e1aa4219c75a32f34c2d62d46dc9d2fb2d3e0b0287e4b7";
  };

  nativeBuildInputs = [ setuptools-git setuptools-scm ];
  propagatedBuildInputs = [ Mako markdown ];

  meta = with lib; {
    description = "Auto-generate API documentation for Python projects.";
    homepage = "https://pdoc3.github.io/pdoc/";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ catern ];
  };
}
