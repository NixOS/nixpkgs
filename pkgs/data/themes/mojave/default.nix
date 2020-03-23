{ stdenv, fetchFromGitHub, fetchurl, glib, gtk-engine-murrine, gtk_engines, inkscape, optipng, sassc, which }:

stdenv.mkDerivation rec {
  pname = "mojave-gtk-theme";
  version = "2020-03-19";

  srcs = [
    (fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      sha256 = "1f120sx092i56q4dx2b8d3nnn9pdw67656446nw702rix7zc5jpx";
    })
    (fetchurl {
      url = "https://github.com/vinceliuice/Mojave-gtk-theme/raw/11741a99d96953daf9c27e44c94ae50a7247c0ed/macOS_Mojave_Wallpapers.tar.xz";
      sha256 = "18zzkwm1kqzsdaj8swf0xby1n65gxnyslpw4lnxcx1rphip0rwf7";
    })
  ];

  sourceRoot = "source";

  nativeBuildInputs = [ glib inkscape optipng sassc which ];

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs .

    for f in render-assets.sh \
             src/assets/gtk-2.0/render-assets.sh \
             src/assets/gtk-3.0/common-assets/render-assets.sh \
             src/assets/gtk-3.0/windows-assets/render-assets.sh \
             src/assets/metacity-1/render-assets.sh \
             src/assets/xfwm4/render-assets.sh
    do
      substituteInPlace $f \
        --replace /usr/bin/inkscape ${inkscape}/bin/inkscape \
        --replace /usr/bin/optipng ${optipng}/bin/optipng
    done

    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  installPhase = ''
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
