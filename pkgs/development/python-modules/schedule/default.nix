{ stdenv
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "schedule";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nrkbbmr9k1bqfmv9wg5aslxzkkifcd62fm04n6844nf5mya00qh";
  };

  buildInputs = [ mock ];

  meta = with stdenv.lib; {
    description = "Python job scheduling for humans";
    homepage = https://github.com/dbader/schedule;
    license = licenses.mit;
  };

}
