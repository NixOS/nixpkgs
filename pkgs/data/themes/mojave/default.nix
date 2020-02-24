{ stdenv, fetchFromGitHub, fetchurl, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "mojave-gtk-theme";
  version = "2020-02-20";

  srcs = [
    (fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      sha256 = "0fbpjfdx53g4qicr97jl1dssykjwwca9xzrfyh53dmd81vr6znpy";
    })
    (fetchurl {
      url = "https://github.com/vinceliuice/Mojave-gtk-theme/raw/11741a99d96953daf9c27e44c94ae50a7247c0ed/macOS_Mojave_Wallpapers.tar.xz";
      sha256 = "18zzkwm1kqzsdaj8swf0xby1n65gxnyslpw4lnxcx1rphip0rwf7";
    })
  ];

  sourceRoot = "source";

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    name= ./install.sh -d $out/share/themes
    install -D -t $out/share/wallpapers ../"macOS Mojave Wallpapers"/*
  '';

  meta = with stdenv.lib; {
    description = "Mac OSX Mojave like theme for GTK based desktop environments";
    homepage = https://github.com/vinceliuice/Mojave-gtk-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
