{ stdenv, fetchurl, cmake }:

let version = "1.0.10"; in

stdenv.mkDerivation {
  name = "libcec-${version}";

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/platform/archive/${version}.tar.gz";
    sha256 = "1kdmi9b62nky4jrb5519ddnw5n7s7m6qyj7rzhg399f0n6f278vb";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Platform library for libcec and Kodi addons";
    homepage = "https://github.com/Pulse-Eight/platform";
    repositories.git = "https://github.com/Pulse-Eight/libcec.git";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
