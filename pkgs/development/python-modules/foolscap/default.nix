{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, twisted
, pyopenssl
, service-identity
}:

buildPythonPackage rec {
  pname = "foolscap";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sqxp4fshnpcv69c2j04v8c22pjak28iwscxv998h2s3054knxz2";
  };

  propagatedBuildInputs = [ mock twisted pyopenssl service-identity ];

  checkPhase = ''
    # Either uncomment this, or remove this custom check phase entirely, if
    # you wish to do battle with the foolscap tests. ~ C.
    # trial foolscap
  '';

  meta = with stdenv.lib; {
    homepage = http://foolscap.lothar.com/;
    description = "Foolscap, an RPC protocol for Python that follows the distributed object-capability model";
    longDescription = ''
      "Foolscap" is the name for the next-generation RPC protocol,
      intended to replace Perspective Broker (part of Twisted).
      Foolscap is a protocol to implement a distributed
      object-capabilities model in Python.
    '';
    # See http://foolscap.lothar.com/trac/browser/LICENSE.
    license = licenses.mit;
  };

}
