{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-resources
, pydsdl
, pyyaml
}:

 buildPythonPackage rec {
  pname = "nunavut";
  version = "1.8.3";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JI+0IpQWikE6vXfpZHWsVjx3JPaVJ/f4oAjTSNs1Wuk=";
  };

  propagatedBuildInputs = [
    importlib-resources
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
