{ stdenv, fetchurl, openssl, makeWrapper, buildPythonApplication
, pytest, dns }:

buildPythonApplication rec {
  name = "${pname}-${majorversion}.${minorversion}";
  pname = "dkimpy";
  majorversion = "0.6";
  minorversion = "2";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/${majorversion}/${majorversion}.${minorversion}/+download/${name}.tar.gz";
    sha256 = "1hagz8qk0v4ijfbcdq4z28bpgr2mkpr498z76i1vam2d50chmakl";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs =  [ openssl dns ];

  patchPhase = ''
    substituteInPlace dknewkey.py --replace \
      /usr/bin/openssl ${openssl}/bin/openssl
  '';

  checkPhase = ''
    python ./test.py
  '';

  postInstall = ''
    mkdir -p $out/bin $out/libexec
    mv $out/bin/*.py $out/libexec
    makeWrapper "$out/libexec/dkimverify.py" $out/bin/dkimverify
    makeWrapper "$out/libexec/dkimsign.py" $out/bin/dkimsign
    makeWrapper "$out/libexec/arcverify.py" $out/bin/arcverify
    makeWrapper "$out/libexec/arcsign.py" $out/bin/arcsign
    makeWrapper "$out/libexec/dknewkey.py" $out/bin/dknewkey
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
