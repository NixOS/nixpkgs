a@{ stdenv, fetchurl, qt4, vlc, automoc4, cmake, phonon }:

let
  pn = "phonon-backend-vlc";
  v = "0.2.0";
  vlc = a.vlc.override { inherit qt4; }; #Force using the same qt version
in

stdenv.mkDerivation {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/${pn}/${v}/src/${pn}-${v}.tar.gz";
    sha256 = "1sac7770vk0ppwbzl9nag387ks7sqmdnm7722kpzafhx1c2r7wsv";
  };

  buildInputs = [ qt4 vlc cmake automoc4 phonon ];

  meta = {
    description = "VideoLAN backend for Phonon multimedia framework";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
