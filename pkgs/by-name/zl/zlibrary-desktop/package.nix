{
  lib,
  fetchzip,
  stdenvNoCC,

  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  undmg,

  nss,
  nspr,
  at-spi2-atk,
  cups,
  dbus,
  libdrm,
  gtk3,
  xorg,
  libgbm,
  libxkbcommon,
  alsa-lib,
  libGL,
  glibc,
  pango,
  cairo,
  expat,
  libgcc,
  libffi,
  glib,
  zlib,
  pcre2,
  util-linux,
  libselinux,
  avahi,
  gnutls,
  harfbuzz,
  fontconfig,
  fribidi,
  gdk-pixbuf,
  libepoxy,
  tinysparql,
  libthai,
  libpng,
  pixman,
  p11-kit,
  libidn2,
  libunistring,
  libtasn1,
  nettle,
  gmp,
  libcap,
  wayland,
  graphite2,
  bzip2,
  brotli,
  libjpeg,
  json-glib,
  libxml2,
  sqlite,
  libdatrie,
  vulkan-loader,
  mesa,
  gvfs,
  libudev-zero,
  pciutils,
  libGLX,
  zstd,
}:

let
  stdenv = stdenvNoCC;
  libraries =
    [
      nss
      nspr
      at-spi2-atk
      cups
      dbus
      libdrm
      gtk3
      libgbm
      libxkbcommon
      alsa-lib
      libGL
      glibc
      expat
      libgcc
      libffi
      glib
      zlib
      pcre2
      util-linux
      libselinux
      avahi
      gnutls
      harfbuzz
      fontconfig
      fribidi
      gdk-pixbuf
      libepoxy
      tinysparql
      libthai
      libpng
      pixman
      p11-kit
      libidn2
      libunistring
      libtasn1
      nettle
      gmp
      libcap
      wayland
      graphite2
      bzip2
      brotli
      libjpeg
      json-glib
      libxml2
      sqlite
      libdatrie
      vulkan-loader
      mesa
      gvfs
      libudev-zero
      pciutils
      libGLX
      zstd
    ]
    ++ (with xorg; [
      libXcomposite
      libXdamage
      libXfixes
      libXrandr
      libXext
      libX11
      libxcb
      libXi
      libXrender
      libXau
      libXdmcp
      libXcursor
      libXinerama
      libxshmfence
    ]);
in
stdenv.mkDerivation {
  pname = "zlibrary-desktop";
  version = "2.4.2";

  src = fetchzip {
    url = "https://web.archive.org/web/20250605013754/https://s3proxy.cdn-zlib.sk/te_public_files/soft/linux/zlibrary-setup-latest.tar.gz";
    hash = "sha256-jEzUapvi53NWagTX5TySNyEuz8dALeO69inli26nO0g=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ] ++ libraries;

  desktopItems = [
    (makeDesktopItem {
      name = "zlibrary-desktop";
      desktopName = "Z-Library";
      comment = "client for the online library Z-Library";
      exec = "z-library";
      categories = [ "Education" ];
    })
  ];

  installPhase =
    let
      phome = "$out/lib/zlibrary-desktop";
    in
    ''
      runHook preInstall

      mkdir -p $out/bin ${phome}

      cp -r * ${phome}
      makeWrapper "${phome}/z-library" $out/bin/z-library \
        --chdir "${phome}" \
        --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath libraries}

      runHook postInstall
    '';

  passthru.updateScript = ./update.rb;

  meta = {
    homepage = "https://z-lib.fm";
    description = "client for the online library Z-Library";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "z-library";
  };
}
