{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "nordic-polar";
  version = "1.6.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v${version}/Nordic-Polar.tar.xz";
      sha256 = "0cym8rcg8jpfraqlfrmymkm0jrsk1s9p7z6vcil4vxbyim9q9w16";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v${version}/Nordic-Polar-standard-buttons.tar.xz";
      sha256 = "0s4wf9nqpa75km905jh03gl2d2hjcdvfacmkdz3njviqm6pwqxsv";
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
