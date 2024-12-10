{
  lib,
  stdenv,
  fetchurl,
  coreutils,
  cctools,
  darwin,
  ncurses,
  libiconv,
  libX11,
  libuuid,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chez-scheme";
  version = "10.0.0";

  src = fetchurl {
    url = "https://github.com/cisco/ChezScheme/releases/download/v${finalAttrs.version}/csv${finalAttrs.version}.tar.gz";
    hash = "sha256-03GZASte0ZhcQGnWqH/xjl4fWi3yfkApkfr0XcTyIyw=";
  };

  nativeBuildInputs =
    lib.optionals stdenv.isDarwin [
      cctools
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      darwin.autoSignDarwinBinariesHook
    ];
  buildInputs = [
    ncurses
    libiconv
    libX11
    libuuid
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=format-truncation";

  /*
    ** We have to fix a few occurrences to tools with absolute
    ** paths in some helper scripts, otherwise the build will fail on
    ** NixOS or in any chroot build.
  */
  patchPhase = ''
    substituteInPlace ./makefiles/installsh \
      --replace-warn "/usr/bin/true" "${coreutils}/bin/true"

    substituteInPlace zlib/configure \
      --replace-warn "/usr/bin/libtool" libtool
  '';

  /*
    ** Don't use configureFlags, since that just implicitly appends
    ** everything onto a --prefix flag, which ./configure gets very angry
    ** about.
    **
    ** Also, carefully set a manual workarea argument, so that we
    ** can later easily find the machine type that we built Chez
    ** for.
  */
  configurePhase = ''
    ./configure --as-is --threads --installprefix=$out --installman=$out/share/man
  '';

  # ** Clean up some of the examples from the build output.
  postInstall = ''
    rm -rf $out/lib/csv${finalAttrs.version}/examples
  '';

  setupHook = ./setup-hook.sh;

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "A powerful and incredibly fast R6RS Scheme compiler";
    homepage = "https://cisco.github.io/ChezScheme/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.unix;
    mainProgram = "scheme";
  };
})
