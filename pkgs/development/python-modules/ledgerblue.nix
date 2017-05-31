{ stdenv, fetchurl, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy
}:

buildPythonPackage rec {
  name = "ledgerblue-${version}";
  version = "0.1.13";

  src = fetchurl {
    url = "mirror://pypi/l/ledgerblue/${name}.tar.gz";
    sha256 = "09bsiylvgax6m47w8r0myaf61xj9j0h1spvadx6fx31qy0iqicw0";
  };

  buildInputs = [ hidapi pycrypto pillow protobuf future ecpy ];

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = licenses.apache2;
    maintainers = with maintainers; [ np ];
  };
}
