{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pydsdl
}:

 buildPythonPackage rec {
  pname = "nunavut";
  version = "1.0.1";
  disabled = pythonOlder "3.5"; # only python>=3.5 is supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gvs3fx2l15y5ffqsxxjfa4p1ydaqbq7qp5nsgb8jbz871358jxm";
  };

  propagatedBuildInputs = [
    pydsdl
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
