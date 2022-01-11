{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, glib
, gtk-engine-murrine
, gtk_engines
, inkscape
, jdupes
, optipng
, sassc
, which
}:

stdenv.mkDerivation rec {
  pname = "mojave-gtk-theme";
  version = "2021-07-20";

  srcs = [
    (fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      sha256 = "08j70kmjhvh06c3ahcracarrfq4vpy0zsp6zkcivbw4nf3bzp2zc";
    })
    (fetchurl {
      url = "https://github.com/vinceliuice/Mojave-gtk-theme/raw/11741a99d96953daf9c27e44c94ae50a7247c0ed/macOS_Mojave_Wallpapers.tar.xz";
      sha256 = "18zzkwm1kqzsdaj8swf0xby1n65gxnyslpw4lnxcx1rphip0rwf7";
    })
  ];

  sourceRoot = "source";

  nativeBuildInputs = [
    glib
    inkscape
    jdupes
    optipng
    sassc
    which
  ];

  buildInputs = [
    gtk_engines
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  # These fixup steps are slow and unnecessary.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  postPatch = ''
    patchShebangs .

    for f in \
      render-assets.sh \
      src/assets/cinnamon/thumbnails/render-thumbnails.sh \
      src/assets/gtk-2.0/render-assets.sh \
      src/assets/gtk/common-assets/render-assets.sh \
      src/assets/gtk/thumbnails/render-thumbnails.sh \
      src/assets/gtk/windows-assets/render-alt-assets.sh \
      src/assets/gtk/windows-assets/render-alt-small-assets.sh \
      src/assets/gtk/windows-assets/render-assets.sh \
      src/assets/gtk/windows-assets/render-small-assets.sh \
      src/assets/metacity-1/render-assets.sh \
      src/assets/xfwm4/render-assets.sh
    do
      substituteInPlace $f \
        --replace /usr/bin/inkscape ${inkscape}/bin/inkscape \
        --replace /usr/bin/optipng ${optipng}/bin/optipng
    done
  '';

  installPhase = ''
    runHook preInstall
    name= ./install.sh --theme all --dest $out/share/themes
    install -D -t $out/share/wallpapers ../"macOS Mojave Wallpapers"/*
    jdupes -l -r $out/share
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mac OSX Mojave like theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Mojave-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
