args: with args;

stdenv.mkDerivation rec {
  name = "extragear-plasma-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/extragear/${name}.tar.bz2";
    sha256 = "1pwvsmdb4z9av6bqh1yk23wgss1wc07rwq47gyxvvi54idpgirx9";
  };

  buildInputs = [ kde4.workspace cmake ];
  patchPhase = ''
    sed -e '/^#include/s@<Plasma@<KDE/Plasma@' -i ../applets/*/*.{h,cpp} 
    fixCmakeDbusCalls ${kde4.workspace}
  '';
}
