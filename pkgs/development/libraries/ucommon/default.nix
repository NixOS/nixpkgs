{ stdenv, fetchurl, pkgconfig
, openssl ? null, zlib ? null, gnutls ? null
}:

let
  xor = a: b: (a || b) && (!(a && b));
in

assert xor (openssl != null) (gnutls != null);
assert !(xor (openssl != null) (zlib != null));

stdenv.mkDerivation rec {
  name = "ucommon-6.3.1";

  src = fetchurl {
    url = "mirror://gnu/commoncpp/${name}.tar.gz";
    sha256 = "1marbwbqnllhm9nh22lvyfjy802pgy1wx7j7kkpkasbm9r0sb6mm";
  };

  buildInputs = [ pkgconfig ];

  # disable flaky networking test
  postPatch = ''
    substituteInPlace test/stream.cpp \
      --replace 'ifndef UCOMMON_SYSRUNTIME' 'if 0'
  '';

  # ucommon.pc has link time depdendencies on -lssl, -lcrypto, -lz, -lgnutls
  propagatedBuildInputs = [ openssl zlib gnutls ];

  doCheck = true;

  meta = {
    description = "C++ library to facilitate using C++ design patterns";
    homepage = http://www.gnu.org/software/commoncpp/;
    license = stdenv.lib.licenses.lgpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
