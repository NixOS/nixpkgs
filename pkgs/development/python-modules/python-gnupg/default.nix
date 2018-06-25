{ stdenv, buildPythonPackage, fetchPypi, gnupg1 }:

buildPythonPackage rec {
  name    = "${pname}-${version}";
  pname   = "python-gnupg";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d158dfc6b54927752b945ebe57e6a0c45da27747fa3b9ae66eccc0d2147ac0d";
  };

  propagatedBuildInputs = [ gnupg1 ];

  # Let's make the library default to our gpg binary
  patchPhase = ''
    substituteInPlace gnupg.py \
    --replace "gpgbinary='gpg'" "gpgbinary='${gnupg1}/bin/gpg'"
    substituteInPlace test_gnupg.py \
    --replace "gpgbinary=GPGBINARY" "gpgbinary='${gnupg1}/bin/gpg'" \
    --replace "test_search_keys" "disabled__test_search_keys"
  '';

  meta = with stdenv.lib; {
    description = "A wrapper for the Gnu Privacy Guard";
    homepage    = https://pypi.python.org/pypi/python-gnupg;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.unix;
  };
}
