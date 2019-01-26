{ stdenv, fetchurl, pkgconfig
, openssl ? null, zlib ? null, gnutls ? null
}:

let
  xor = a: b: (a || b) && (!(a && b));
in

assert xor (openssl != null) (gnutls != null);
assert !(xor (openssl != null) (zlib != null));

stdenv.mkDerivation rec {
  name = "ucommon-7.0.0";

  src = fetchurl {
    url = "mirror://gnu/commoncpp/${name}.tar.gz";
    sha256 = "6ac9f76c2af010f97e916e4bae1cece341dc64ca28e3881ff4ddc3bc334060d7";
  };

  nativeBuildInputs = [ pkgconfig ];

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
    homepage = https://www.gnu.org/software/commoncpp/;
    license = stdenv.lib.licenses.lgpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
