{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
  dominate,
  beautifulsoup4,
  docutils,
  sphinx,
}:

buildPythonPackage rec {
  pname = "alectryon";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cWSygLoIC7KOdAZdYlJQw3nOug9SU6RHG4697aL7nQE=";
  };

  propagatedBuildInputs = [
    pygments
    dominate
    beautifulsoup4
    docutils
    sphinx
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cpitclaudel/alectryon";
    description = "Collection of tools for writing technical documents that mix Coq code and prose";
    mainProgram = "alectryon";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
