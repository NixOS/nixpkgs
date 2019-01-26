{ stdenv, buildPythonPackage, fetchPypi, gnupg1 }:

buildPythonPackage rec {
  pname   = "python-gnupg";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45daf020b370bda13a1429c859fcdff0b766c0576844211446f9266cae97fb0e";
  };

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
