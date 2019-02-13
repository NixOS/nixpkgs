{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "nordic-${version}";
  version = "1.5.4";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic.tar.xz";
      sha256 = "0m00hwr6ms9fzlpl97d972wvgq5l0m11mpn213248a8sqbh2zz9g";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-blue.tar.xz";
      sha256 = "05k1m9f0q4mfaqp2as3ymjsqmyz0bs5cd576srd5v952dzxmmbm2";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-standard-buttons.tar.xz";
      sha256 = "1qps13fpp8y83c25c51w7kyds266gmks8c7kjp23iybij2lkny1m";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-blue-standard-buttons.tar.xz";
      sha256 = "1c0j6qsxa6zahrl9ad0q6pczgbmm8qn9qsd7k41yk2ndh9iqzr5y";
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
