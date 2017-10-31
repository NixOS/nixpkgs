{ stdenv, fetchurl, cmake }:

let version = "2.0.1"; in

stdenv.mkDerivation {
  name = "p8-platform-${version}";

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/platform/archive/p8-platform-${version}.tar.gz";
    sha256 = "1kslq24p2zams92kc247qcczbxb2n89ykk9jfyiilmwh7qklazp9";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Platform library for libcec and Kodi addons";
    homepage = https://github.com/Pulse-Eight/platform;
    repositories.git = "https://github.com/Pulse-Eight/platform.git";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
