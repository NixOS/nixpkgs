{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pydsdl
, pyyaml
}:

 buildPythonPackage rec {
  pname = "nunavut";
  version = "1.5.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c57a9ffe6d462b0ad1ea49ac3ce9ebb3e8d43b2adf653dbe47eaf1b13be3c3b";
  };

  propagatedBuildInputs = [
    pydsdl
    pyyaml
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  # No tests in pypy package and no git tags yet for release versions, see
  # https://github.com/UAVCAN/nunavut/issues/182
  doCheck = false;

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
