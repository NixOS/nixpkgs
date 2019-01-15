{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "nordic-polar-${version}";
  version = "1.3.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v${version}/Nordic-Polar.tar.xz";
      sha256 = "1c5zgymkwd89fr680c49siwbkhfbay56iq9vlyqkj1dp0xnc528s";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic-Polar/releases/download/v${version}/Nordic-Polar-standard-buttons.tar.xz";
      sha256 = "0nxzcgqzc42qvnhafranz6rwanqb4wzf9ychm5m4yrlp3ngw38p4";
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
