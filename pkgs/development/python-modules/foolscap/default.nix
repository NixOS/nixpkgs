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
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8498c7e9eaecb5b19be74b18d55c2086440be08de29f2bb507f9b505757467ff";
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
