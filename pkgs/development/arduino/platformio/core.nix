{ stdenv, buildPythonPackage, fetchPypi
, bottle, click, colorama
, lockfile, pyserial, requests
, semantic-version
, git
}:

buildPythonPackage rec {
  pname = "platformio";
  version = "3.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l4s2xh1p9h767amk9zapzivz4irl2y3kff3dna6icvsgq6rz011";
  };

  propagatedBuildInputs =  [
    bottle click colorama git lockfile
    pyserial requests semantic-version
  ];

  patches = [ ./fix-searchpath.patch ];

  meta = with stdenv.lib; {
    description = "An open source ecosystem for IoT development";
    homepage = http://platformio.org;
    maintainers = with maintainers; [ mog makefu ];
    license = licenses.asl20;
  };
}
