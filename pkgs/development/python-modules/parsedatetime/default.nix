{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, future
}:

buildPythonPackage rec {
  pname = "parsedatetime";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ future ];

  meta = with stdenv.lib; {
    description = "Parse human-readable date/time text";
    homepage = "https://github.com/bear/parsedatetime";
    license = licenses.asl20;
  };

}
