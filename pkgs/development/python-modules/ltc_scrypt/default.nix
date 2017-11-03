{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ltc_scrypt";
  version = "1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h90hh3iw4i7zs7jgskdjlk8gi97b3v2zqsxdfwdvhrrnhpvv856";
  };

  meta = with stdenv.lib; {
    description = "Bindings for scrypt proof of work used by Litecoin";
    homepage = https://pypi.python.org/pypi/ltc_scrypt;
    maintainers = with maintainers; [ asymmetric ];
    license = licenses.bsd2;
  };
}
