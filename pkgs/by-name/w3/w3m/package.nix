{
  lib,
  stdenv,
  fetchFromSourcehut,
  fetchpatch,
  ncurses,
  boehmgc,
  gettext,
  zlib,
  sslSupport ? true,
  openssl,
  graphicsSupport ? !stdenv.hostPlatform.isDarwin,
  imlib2,
  x11Support ? graphicsSupport,
  libX11,
  mouseSupport ? !stdenv.hostPlatform.isDarwin,
  gpm-ncurses,
  perl,
  man,
  pkg-config,
  buildPackages,
  w3m,
  testers,
  updateAutotoolsGnuConfigScriptsHook,
}:

let
  mktable = buildPackages.stdenv.mkDerivation {
    name = "w3m-mktable";
    inherit (w3m) src;
    nativeBuildInputs = [
      pkg-config
      boehmgc
    ];
    makeFlags = [ "mktable" ];
    installPhase = ''
      install -D mktable $out/bin/mktable
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "w3m";
  version = "0.5.5";

  src = fetchFromSourcehut {
    owner = "~rkta";
    repo = "w3m";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rz9tNkMg5xUqMpMdK2AQlKjCJlCjgLQOkj4A/eyPm0M=";
  };

  env = {
    NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isSunOS "-lsocket -lnsl";

    # we must set these so that the generated files (e.g. w3mhelp.cgi) contain
    # the correct paths.
    PERL = "${perl}/bin/perl";
    MAN = "${man}/bin/man";

    # for w3mimgdisplay
    # see: https://bbs.archlinux.org/viewtopic.php?id=196093
    LIBS = lib.optionalString x11Support "-lX11";
  };

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  patches = [
    ./RAND_egd.libressl.patch
    (fetchpatch {
      name = "https.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/https.patch?h=w3m-mouse&id=5b5f0fbb59f674575e87dd368fed834641c35f03";
      sha256 = "08skvaha1hjyapsh8zw5dgfy433mw2hk7qy9yy9avn8rjqj7kjxk";
    })
  ];

  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    ln -s ${mktable}/bin/mktable mktable
    # stop make from recompiling mktable
    sed -i -e 's!mktable.*:.*!mktable:!' Makefile.in
  '';

  # updateAutotoolsGnuConfigScriptsHook necessary to build on FreeBSD native pending inclusion of
  # https://git.savannah.gnu.org/cgit/config.git/commit/?id=e4786449e1c26716e3f9ea182caf472e4dbc96e0
  nativeBuildInputs = [
    pkg-config
    gettext
    updateAutotoolsGnuConfigScriptsHook
  ];
  buildInputs = [
    ncurses
    boehmgc
    zlib
  ]
  ++ lib.optional sslSupport openssl
  ++ lib.optional mouseSupport gpm-ncurses
  ++ lib.optional graphicsSupport imlib2
  ++ lib.optional x11Support libX11;

  postInstall = lib.optionalString graphicsSupport ''
    ln -s $out/libexec/w3m/w3mimgdisplay $out/bin
  '';

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-gc=${boehmgc.dev}"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_func_setpgrp_void=${if stdenv.hostPlatform.isBSD then "no" else "yes"}"
  ]
  ++ lib.optional graphicsSupport "--enable-image=${lib.optionalString x11Support "x11,"}fb"
  ++ lib.optional (graphicsSupport && !x11Support) "--without-x";

  preConfigure = ''
    substituteInPlace ./configure --replace "/lib /usr/lib /usr/local/lib /usr/ucblib /usr/ccslib /usr/ccs/lib /lib64 /usr/lib64" /no-such-path
    substituteInPlace ./configure --replace /usr /no-such-path
  '';

  enableParallelBuilding = false;

  passthru.tests.version = testers.testVersion {
    inherit (finalAttrs) version;
    package = w3m;
    command = "w3m -version";
  };

  meta = {
    homepage = "https://git.sr.ht/~rkta/w3m";
    changelog = "https://git.sr.ht/~rkta/w3m/tree/v${finalAttrs.version}/item/NEWS";
    description = "Text-mode web browser";
    maintainers = with lib.maintainers; [
      anthonyroussel
      toastal
    ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    mainProgram = "w3m";
  };
})
