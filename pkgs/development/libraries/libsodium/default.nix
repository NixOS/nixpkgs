{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-0.4.3";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "0hk0zca1kpj6xlc2j2qx9qy7287pi0896frmxq5d7qmcwsdf372r";
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
