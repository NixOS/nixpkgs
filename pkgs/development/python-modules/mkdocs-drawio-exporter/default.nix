{ buildPythonPackage
, drawio-headless
, fetchPypi
, isPy3k
, lib
, mkdocs
}:

buildPythonPackage rec {
  pname = "mkdocs-drawio-exporter";
  version = "0.8.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9cvA186FS6bHmpOrv4OfPZ5kRfgfafBfaWxgWJIlwwA=";
  };

  propagatedBuildInputs = [ mkdocs drawio-headless ];

  pythonImportsCheck = [ "mkdocsdrawioexporter" ];

  meta = with lib; {
    description = "Exports your Draw.io diagrams at build time for easier embedding into your documentation.";
    homepage = "https://github.com/LukeCarrier/mkdocs-drawio-exporter/";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
    longDescription = ''
      Exports your Draw.io diagrams at build time for easier embedding into your documentation.
    '';
  };
}
