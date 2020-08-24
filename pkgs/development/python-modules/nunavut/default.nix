{ lib, buildPythonPackage, pythonOlder, fetchPypi, pydsdl }:

 buildPythonPackage rec {
  pname = "nunavut";
  version = "0.3.4";
  disabled = pythonOlder "3.5"; # only python>=3.5 is supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "5455946d069ac8cfd86e93d3977c1bd31ee7d68d22accdf130addb038e73564a";
  };

  propagatedBuildInputs = [
    pydsdl
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  # repo doesn't contain tests, ensure imports aren't broken
  pythonImportsCheck = [
    "nunavut"
  ];

  meta = with lib; {
    description = "A UAVCAN DSDL template engine";
    longDescription = ''
      It exposes a pydsdl abstract syntax tree to Jinja2 templates allowing
      authors to generate code, schemas, metadata, documentation, etc.
    '';
    homepage = "https://nunavut.readthedocs.io/";
    maintainers = with maintainers; [ wucke13 ];
    license = with licenses; [ bsd3 mit ];
  };
}
