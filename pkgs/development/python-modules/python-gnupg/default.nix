{ lib, buildPythonPackage, fetchPypi, gnupg }:

buildPythonPackage rec {
  pname   = "python-gnupg";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b64de1ae5cedf872b437201a566fa2c62ce0c95ea2e30177eb53aee1258507d7";
  };

  # Let's make the library default to our gpg binary
  patchPhase = ''
    substituteInPlace gnupg.py \
    --replace "gpgbinary='gpg'" "gpgbinary='${gnupg}/bin/gpg'"
    substituteInPlace test_gnupg.py \
    --replace "gpgbinary=GPGBINARY" "gpgbinary='${gnupg}/bin/gpg'" \
    --replace "test_search_keys" "disabled__test_search_keys"
  '';

  meta = with lib; {
    description = "A wrapper for the Gnu Privacy Guard";
    homepage    = "https://pypi.python.org/pypi/python-gnupg";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.unix;
  };
}
