{ stdenv, buildPythonPackage, fetchPypi, six, attrs, twisted, pyopenssl, service-identity, autobahn, treq, mock }:

buildPythonPackage rec {
  version = "0.3.1";
  pname = "magic-wormhole-mailbox-server";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q6zhbx8fcpk7rchclm7yqcxdsc1x97hki2ji61sa544r5xvxv55";
  };

  propagatedBuildInputs = [ six attrs twisted pyopenssl service-identity autobahn ];
  checkInputs = [ treq mock ];

  meta = with stdenv.lib; {
    description = "Securely transfer data between computers";
    homepage = https://github.com/warner/magic-wormhole-mailbox-server;
    license = licenses.mit;
  };
}
