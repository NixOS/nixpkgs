{ stdenv, fetchurl, qt47, vlc, automoc4, cmake }:

let
  pn = "phonon-backend-vlc";
  v = "0.2.0";
in

stdenv.mkDerivation {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/${pn}/${v}/src/${pn}-${v}.tar.gz";
    sha256 = "1sac7770vk0ppwbzl9nag387ks7sqmdnm7722kpzafhx1c2r7wsv";
  };

  buildInputs = [ qt47 vlc cmake automoc4 ];

  meta = {
    description = "VideoLAN backend for Phonon multimedia framework";
    inherit (qt47) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
