{ stdenv
, buildPythonPackage
, fetchurl
, isPy34
, isPy35
, mock
}:

buildPythonPackage rec {
  pname = "IMAPClient";
  version = "0.13";
  disabled = isPy34 || isPy35;

  src = fetchurl {
    url = "https://freshfoo.com/projects/IMAPClient/${pname}-${version}.tar.gz";
    sha256 = "0v7kd1crdbff0rmh4ddm5qszkis6hpk9084qh94al8h7g4y9l3is";
  };

  buildInputs = [ mock ];

  preConfigure = ''
    sed -i '/distribute_setup/d' setup.py
    substituteInPlace setup.py --replace "mock==0.8.0" "mock"
  '';

  meta = with stdenv.lib; {
    homepage = https://imapclient.readthedocs.io/en/2.1.0/;
    description = "Easy-to-use, Pythonic and complete IMAP client library";
    license = licenses.bsd3;
  };

}
