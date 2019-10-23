{ stdenv, buildPythonPackage, fetchPypi, six, attrs, twisted, pyopenssl, service-identity, autobahn, treq, mock }:

buildPythonPackage rec {
  version = "0.4.1";
  pname = "magic-wormhole-mailbox-server";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yw8i8jv5iv1kkz1aqimskw7fpichjn6ww0fq0czbalwj290bw8s";
  };

  propagatedBuildInputs = [ six attrs twisted pyopenssl service-identity autobahn ];
  checkInputs = [ treq mock ];

  meta = with stdenv.lib; {
    description = "Securely transfer data between computers";
    homepage = https://github.com/warner/magic-wormhole-mailbox-server;
    license = licenses.mit;
  };
}
