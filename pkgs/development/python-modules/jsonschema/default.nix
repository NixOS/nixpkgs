{ stdenv, buildPythonPackage, fetchPypi, python
, nose, mock, vcversioner, functools32 }:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00kf3zmpp9ya4sydffpifn0j0mzm342a2vzh82p6r0vh10cg7xbg";
  };

  buildInputs = [ nose mock vcversioner ];
  propagatedBuildInputs = [ functools32 ];

  patchPhase = ''
    substituteInPlace jsonschema/tests/test_jsonschema_test_suite.py \
      --replace "python" "${python}/bin/${python.executable}"
  '';

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = https://github.com/Julian/jsonschema;
    description = "An implementation of JSON Schema validation for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
