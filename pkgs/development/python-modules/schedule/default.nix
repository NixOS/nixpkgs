{ stdenv
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "schedule";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9fb5181283de4db6e701d476dd01b6a3dd81c38462a54991ddbb9d26db857c9";
  };

  buildInputs = [ mock ];

  meta = with stdenv.lib; {
    description = "Python job scheduling for humans";
    homepage = https://github.com/dbader/schedule;
    license = licenses.mit;
  };

}
