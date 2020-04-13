{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, future
}:

buildPythonPackage rec {
  pname = "parsedatetime";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2e9ddb1e463de871d32088a3f3cea3dc8282b1b2800e081bd0ef86900451667";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ future ];

  meta = with stdenv.lib; {
    description = "Parse human-readable date/time text";
    homepage = "https://github.com/bear/parsedatetime";
    license = licenses.asl20;
  };

}
