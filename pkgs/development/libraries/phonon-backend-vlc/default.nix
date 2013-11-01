{ stdenv, fetchurl, xz, qt4, vlc, automoc4, cmake, phonon }:

let
  pname = "phonon-backend-vlc";
  v = "0.5.0";
  vlc_ = vlc.override { inherit qt4; }; #Force using the same qt version
in

stdenv.mkDerivation {
  name = "${pname}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${v}/src/${pname}-${v}.tar.xz";
    sha256 = "1233szd05ahaxyk1sjis374n90m40svfks2aq9jx3g3lxygzwmi2";
  };

  nativeBuildInputs = [ cmake automoc4 xz ];

  buildInputs = [ qt4 vlc_ phonon ];

  meta = {
    description = "VideoLAN backend for Phonon multimedia framework";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
