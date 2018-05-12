{ stdenv, fetchPypi, openssl, makeWrapper, buildPythonPackage
, pytest, dnspython, pynacl, authres, python }:

buildPythonPackage rec {
  pname = "dkimpy";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d4hkviap5mv58nhmbqp5rmd86ah5r8nib8ni1k7abxx2bkbajzp";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs =  [ openssl dnspython pynacl authres ];

  patchPhase = ''
    substituteInPlace dknewkey.py --replace \
      /usr/bin/openssl ${openssl}/bin/openssl
  '';

  checkPhase = ''
    ${python.interpreter} ./test.py
  '';

  postInstall = ''
    rm $out/bin/*.pyc
    pushd $out/bin
    mv arcsign.py arcsign
    mv arcverify.py arcverify
    mv dkimsign.py dkimsign
    mv dkimverify.py dkimverify
    mv dknewkey.py dknewkey
    popd
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
