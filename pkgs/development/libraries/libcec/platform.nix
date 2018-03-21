{ stdenv, fetchurl, cmake }:

let version = "2.1.0.1"; in

stdenv.mkDerivation {
  name = "p8-platform-${version}";

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/platform/archive/p8-platform-${version}.tar.gz";
    sha256 = "18381y54f7d18ckpzf9cfxbz1ws6imprbbm9pvhcg5c86ln8skq6";
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
