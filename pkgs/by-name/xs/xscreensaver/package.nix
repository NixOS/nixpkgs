{
  lib,
  stdenv,
  fetchurl,
  coreutils,
  gdk-pixbuf,
  gdk-pixbuf-xlib,
  gettext,
  gle,
  gtk3,
  intltool,
  libGL,
  libGLU,
  libX11,
  libXext,
  libXft,
  libXi,
  libXinerama,
  libXrandr,
  libXt,
  libXxf86vm,
  libxml2,
  makeWrapper,
  pam,
  perlPackages,
  xorg,
  pkg-config,
  systemd,
  forceInstallAllHacks ? true,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  nixosTests,
  replaceVars,
  wrapperPrefix ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xscreensaver";
  version = "6.13";

  src = fetchurl {
    url = "https://www.jwz.org/xscreensaver/xscreensaver-${finalAttrs.version}.tar.gz";
    hash = "sha256-pzFI3SFifP8udRMcjgwbCV8zTGiyLgnzbTfMJ5YRZ7c=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    intltool
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    gdk-pixbuf-xlib
    gettext
    gle
    gtk3
    libGL
    libGLU
    libX11
    libXext
    libXft
    libXi
    libXinerama
    libXrandr
    libXt
    libXxf86vm
    libxml2
    pam
    perlPackages.LWPProtocolHttps
    perlPackages.MozillaCA
    perlPackages.perl
  ]
  ++ lib.optionals withSystemd [ systemd ];

  postPatch = ''
    pushd hacks
    patchShebangs check-configs.pl munge-ad.pl xml2man.pl
    popd
  '';

  patches = [
    (replaceVars ./xscreensaver-wrapper-prefix.patch {
      inherit wrapperPrefix;
    })
  ];

  preConfigure = ''
    # Fix installation paths for GTK resources.
    sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' \
      -i driver/Makefile.in po/Makefile.in.in
  '';

  configureFlags = [
    "--with-app-defaults=${placeholder "out"}/share/xscreensaver/app-defaults"
  ];

  # "marbling" has NEON code that mixes signed and unsigned vector types
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isAarch "-flax-vector-conversions";

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH : "$out/libexec/xscreensaver" \
        --prefix PATH : "${
          lib.makeBinPath [
            coreutils
            perlPackages.perl
            xorg.appres
          ]
        }" \
        --prefix PERL5LIB ':' $PERL5LIB
    done
  ''
  + lib.optionalString forceInstallAllHacks ''
    make -j$NIX_BUILD_CORES -C hacks/glx dnalogo
    cat hacks/Makefile.in \
      | grep -E '([a-z0-9]+):[[:space:]]*\1[.]o' | cut -d : -f 1 | xargs make -j$NIX_BUILD_CORES -C hacks
    cat hacks/glx/Makefile.in \
      | grep -E '([a-z0-9]+):[[:space:]]*\1[.]o' | cut -d : -f 1 | xargs make -j$NIX_BUILD_CORES -C hacks/glx
    cp -f $(find hacks -type f -perm -111 "!" -name "*.*" ) "$out/libexec/xscreensaver"
  '';

  passthru.tests = {
    xscreensaver = nixosTests.xscreensaver;
  };

  meta = {
    homepage = "https://www.jwz.org/xscreensaver/";
    description = "Set of screensavers";
    downloadPage = "https://www.jwz.org/xscreensaver/download.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.unix;
  };
})
