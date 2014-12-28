{stdenv, fetchurl, zeromq4}:

stdenv.mkDerivation rec {
  baseName="czmq";
  version="3.0.0-rc1";
  name="${baseName}-${version}";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "1g3rk3fz7xzsbqcdcwn0x18nmiyr70k47kg00gdrq8g10li8mmd9";
  };

  buildInputs = [ zeromq4 ];

  meta = {
    license = stdenv.lib.licenses.mpl20;
    homepage = "http://czmq.zeromq.org/";
    description = "High-level C Binding for ZeroMQ";
  };
}
