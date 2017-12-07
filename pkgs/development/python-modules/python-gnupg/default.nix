{ stdenv, buildPythonPackage, fetchPypi, gnupg1 }:

buildPythonPackage rec {
  name    = "${pname}-${version}";
  pname   = "python-gnupg";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06hfw9cmiw5306fyisp3kzg1hww260qzip829g7y7pj1mwpb0izg";
  };

  propagatedBuildInputs = [ gnupg1 ];

  # Let's make the library default to our gpg binary
  patchPhase = ''
    substituteInPlace gnupg.py \
    --replace "gpgbinary='gpg'" "gpgbinary='${gnupg1}/bin/gpg'"
    substituteInPlace test_gnupg.py \
    --replace "gpgbinary=GPGBINARY" "gpgbinary='${gnupg1}/bin/gpg'"
  '';

  meta = with stdenv.lib; {
    description = "A wrapper for the Gnu Privacy Guard";
    homepage    = https://pypi.python.org/pypi/python-gnupg;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.unix;
  };
}
