{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-0.4.5";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "0cmcw479p866r6cjh20wzjr84pdn0mfswr5h57mw1siyylnj1mbs";
  };

  NIX_LDFLAGS = "-lssp";

  doCheck = true;

  meta = {
    description = "Version of NaCl with harwdare tests at runtime, not build time";
    license = "ISC";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
