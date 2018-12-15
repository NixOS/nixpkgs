{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, future
}:

buildPythonPackage rec {
  pname = "parsedatetime";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vkrmd398s11h1zn3zaqqsiqhj9lwy1ikcg6irx2lrgjzjg3rjll";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ future ];

  meta = with stdenv.lib; {
    description = "Parse human-readable date/time text";
    homepage = "https://github.com/bear/parsedatetime";
    license = licenses.asl20;
  };

}
