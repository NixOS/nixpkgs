{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, python
}:

buildPythonPackage rec {
  pname = "isodate";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31";
  };

  # Judging from SyntaxError
  doCheck = !(isPy3k);

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s src/isodate/tests
  '';

  meta = with stdenv.lib; {
    description = "ISO 8601 date/time parser";
    homepage = http://cheeseshop.python.org/pypi/isodate;
    license = licenses.bsd0;
  };

}
