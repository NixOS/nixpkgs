{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mate-common";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1xx7qrw8kc6355r1a1nybncf8s2rxjb2nqzw0gv2r5j5sqx8fzgf";
  };

  meta = {
    description = "Common files for development of MATE packages";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
