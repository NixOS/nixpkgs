{ stdenv, fetchPypi, openssl, buildPythonPackage
, pytest, dnspython, pynacl, authres, python }:

buildPythonPackage rec {
  pname = "dkimpy";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83d5ddc1b83304dbccba1dc7b9e0ee37bec4269bb9ad5779480991525c3811d6";
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
