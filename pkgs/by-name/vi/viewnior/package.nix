{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  gtk3,
  libpng,
  exiv2,
  lcms,
  intltool,
  gettext,
  shared-mime-info,
  glib,
  gdk-pixbuf,
  perl,
  wrapGAppsHook3,
  webp-pixbuf-loader,
  gnome,
  librsvg,
}:

stdenv.mkDerivation rec {
  pname = "viewnior-gtk3";
  version = "1.8-unstable-2023-11-23";

  src = fetchFromGitHub {
    #owner = "hellosiyan";
    #repo = "Viewnior";
    owner = "Artturin";
    repo = "Viewnior";
    # https://github.com/hellosiyan/Viewnior/pull/142
    rev = "23ce6e5630b24509d8009f17a833ad9e59b85fab";
    hash = "sha256-+/f0+og1Dd7eJK7P83+q4lf4SjzW2g6qNk8ZTxNAuDA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    intltool
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libpng
    exiv2
    lcms
    shared-mime-info
    glib
    gdk-pixbuf
    perl
  ];

  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          webp-pixbuf-loader
          librsvg
        ];
      }
    }"

    # gtk3 viewnior can be launched in wayland mode and does so by default
    # but moving around in a zoomed in image doesn't work
    gappsWrapperArgs+=(
      --set-default GDK_BACKEND x11
    )
  '';

  meta = with lib; {
    description = "Fast and simple image viewer";
    longDescription = ''
      Viewnior is insipred by big projects like Eye of Gnome, because of it's
      usability and richness,and by GPicView, because of it's lightweight design and
      minimal interface. So here comes Viewnior - small and light, with no compromise
      with the quality of it's functions. The program is made with better integration
      in mind (follows Gnome HIG2).
    '';
    license = licenses.gpl3;
    homepage = "https://siyanpanayotov.com/project/viewnior/";
    maintainers = with maintainers; [
      smironov
      artturin
    ];
    platforms = platforms.gnu ++ platforms.linux;
    mainProgram = "viewnior";
  };
}
