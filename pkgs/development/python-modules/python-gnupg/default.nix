{ stdenv, buildPythonPackage, fetchPypi, gnupg }:

buildPythonPackage rec {
  pname   = "python-gnupg";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01gckjhvsmr6kfwfk4qdxm5jz8nq8zilbjhzpzpiab6d96cyalrk";
  };

  # Let's make the library default to our gpg binary
  patchPhase = ''
    substituteInPlace gnupg.py \
    --replace "gpgbinary='gpg'" "gpgbinary='${gnupg}/bin/gpg'"
    substituteInPlace test_gnupg.py \
    --replace "gpgbinary=GPGBINARY" "gpgbinary='${gnupg}/bin/gpg'" \
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
