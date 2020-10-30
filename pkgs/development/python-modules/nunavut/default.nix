{ lib, buildPythonPackage, pythonOlder, fetchPypi, pydsdl }:

 buildPythonPackage rec {
  pname = "nunavut";
  version = "0.3.6";
  disabled = pythonOlder "3.5"; # only python>=3.5 is supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "434edabdc431b9af719896e0de4bd0deead657777d1d8aa4e3cd0dcdff6298bc";
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
