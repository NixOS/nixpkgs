{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "nordic-polar-${version}";
  version = "1.4.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v${version}/Nordic-Polar.tar.xz";
      sha256 = "0sw4m1njnxal1kkiipsvfg9ndzxsf9rxfba5vhwswyzk388264xa";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v${version}/Nordic-Polar-standard-buttons.tar.xz";
      sha256 = "0ix0x0pnhfd1lrfj7a7n8xfg8vvzg7m0dzrsj8gzpav6wvwlypiy";
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
