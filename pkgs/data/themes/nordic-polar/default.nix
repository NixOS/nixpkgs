{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "nordic-polar-${version}";
  version = "1.5.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v.${version}/Nordic-Polar.tar.xz";
      sha256 = "0ddccxvyf929045x6fm8xyx6rvb0d6wh6pylycwgqqm4vxbdwnly";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v.${version}/Nordic-Polar-standard-buttons.tar.xz";
      sha256 = "0q0qfy0aw80rds6isx3pjrqx4zrq2crxrm29nrmyzh4gr7n17li6";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Nordic-Polar* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
  '';

  meta = with stdenv.lib; {
    description = "Gtk theme created using the awesome Nord color pallete";
    homepage = https://github.com/EliverLara/Nordic-Polar;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
