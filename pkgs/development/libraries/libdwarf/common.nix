{ lib, stdenv, fetchurl, buildInputs, sha512, version, libelf, url }:

stdenv.mkDerivation rec {
  pname = "libdwarf";
  inherit version;

  src = fetchurl {
    inherit url sha512;
  };

  configureFlags = [ "--enable-shared" "--disable-nonshared" ];

  inherit buildInputs;

  outputs = [ "bin" "lib" "dev" "out" ];

  meta = {
    homepage = "https://github.com/davea42/libdwarf-code";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.atry ];
  };
}
