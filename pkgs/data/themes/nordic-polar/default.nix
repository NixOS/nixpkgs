{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "nordic-polar";
  version = "1.9.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v${version}/Nordic-Polar.tar.xz";
      sha256 = "1583mx8frkl5w26myczbyrggrp07lmpsfj00h1bzicw6lz8jbxf1";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v${version}/Nordic-Polar-standard-buttons.tar.xz";
      sha256 = "1n2qys0xcg1k28bwfrrr44cqz7q2rnfj6ry6qgd67ivgh63kmcq6";
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
    homepage = "https://github.com/EliverLara/Nordic-Polar";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
