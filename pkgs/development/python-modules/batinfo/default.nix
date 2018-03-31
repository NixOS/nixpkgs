{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "batinfo";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gyzkxzvj5l6qrw706bnm3cckqzzzbrjr7jkxc087d7775a73499";
  };

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/nicolargo/batinfo;
    description = "A simple Python lib to retrieve battery information";
    license = licenses.lgpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ koral ];
  };
}
