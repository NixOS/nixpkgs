{ stdenv, fetchPypi, openssl, buildPythonPackage
, pytest, dnspython, pynacl, authres, python }:

buildPythonPackage rec {
  pname = "dkimpy";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rq3543m0q7kfl02l8ji4c35qbxb99h2mzjaxbaxfrlk6dcpk76j";
};

  checkInputs = [ pytest ];
  propagatedBuildInputs =  [ openssl dnspython pynacl authres ];

  patchPhase = ''
    substituteInPlace dkim/dknewkey.py --replace \
      /usr/bin/openssl ${openssl}/bin/openssl
  '';

  checkPhase = ''
    ${python.interpreter} ./test.py
  '';

  meta = with stdenv.lib; {
    description = "DKIM + ARC email signing/verification tools + Python module";
    longDescription = ''
      Python module that implements DKIM (DomainKeys Identified Mail) email
      signing and verification. It also provides a number of convєnient tools
      for command line signing and verification, as well as generating new DKIM
      records. This version also supports the experimental Authenticated
      Received Chain (ARC) protocol.
    '';
    homepage = https://launchpad.net/dkimpy;
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
