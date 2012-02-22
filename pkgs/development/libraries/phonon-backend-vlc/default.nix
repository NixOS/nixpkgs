a@{ stdenv, fetchurl, xz, qt4, vlc, automoc4, cmake, phonon }:

let
  pn = "phonon-backend-vlc";
  v = "0.5.0";
  vlc = a.vlc.override { inherit qt4; }; #Force using the same qt version
in

stdenv.mkDerivation {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pn}/${v}/src/${pn}-${v}.tar.xz";
    sha256 = "2256fe9fef74bcd165c24ae8e9b606a48264c9193a4a1da6ef0aaa02dad76388";
  };

  buildInputs = [ xz qt4 vlc cmake automoc4 phonon ];

  meta = {
    description = "VideoLAN backend for Phonon multimedia framework";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
