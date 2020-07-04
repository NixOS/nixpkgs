{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, future
}:

buildPythonPackage rec {
  pname = "parsedatetime";
  version = "2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ future ];

  meta = with stdenv.lib; {
    description = "Parse human-readable date/time text";
    homepage = "https://github.com/bear/parsedatetime";
    license = licenses.asl20;
  };

}
