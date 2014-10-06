{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-0.7.0";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "0s4iis5h7yh27kamwic3rddyp5ra941bcqcawa37grjvl78zzjjc";
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
