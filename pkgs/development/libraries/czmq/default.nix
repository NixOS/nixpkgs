{ stdenv, fetchurl, zeromq }:

stdenv.mkDerivation rec {
  baseName="czmq";
  version="3.0.0-rc1";
  name="${baseName}-${version}";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "1g3rk3fz7xzsbqcdcwn0x18nmiyr70k47kg00gdrq8g10li8mmd9";
  };

  buildInputs = [ zeromq ];

  meta = with stdenv.lib; {
    homepage = "http://czmq.zeromq.org/";
    description = "High-level C Binding for ZeroMQ";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
