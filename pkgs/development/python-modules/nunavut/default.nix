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
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rrt26sEdT3EM1KQHnHQogodj+7QwRJ05f8t7Tn679ZE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pydsdl ~= 1.16" "pydsdl"
  '';

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
