{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "nordic-${version}";
  version = "1.6.5";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic.tar.xz";
      sha256 = "163g1kh92fhgbwi91053xs39bpdd032w2v67c3jf8lf4cgvkwggp";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-blue.tar.xz";
      sha256 = "05qq1v8sil8s51aa78q2najcqdnkpgdzc8dckrx47wy36cfxbxwz";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-standard-buttons.tar.xz";
      sha256 = "17r450xxd8v8125a4bwd0yj3f3vnwcad2f19a0vgmk63s9grvkg0";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-blue-standard-buttons.tar.xz";
      sha256 = "0894naw0wkl2h9l27qz9h1k02dfgfqyb02icmgadg0cb44j3zlpb";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Nordic* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
  '';

  meta = with stdenv.lib; {
    description = "Dark Gtk theme created using the awesome Nord color pallete";
    homepage = https://github.com/EliverLara/Nordic;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
