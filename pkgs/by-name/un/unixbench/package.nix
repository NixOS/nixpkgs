{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  pandoc,
  installShellFiles,
  perl,
  libxext,
  libx11,
  x11perf,
  libGLX,
  coreutils,
  unixtools,
  runtimeShell,
  targetPackages,
  gnugrep,
  gawk,
  withGL ? true,
  withX11perf ? true,
}:
stdenv.mkDerivation rec {
  pname = "unixbench";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "kdlucas";
    repo = "byte-unixbench";
    tag = "v${version}";
    hash = "sha256-GQYejkIf7g2abHafJJQTl0nWqRGsg9VDtYQgyBY/jOg=";
  };

  patches = [
    ./common.patch
  ];

  patchFlags = [ "-p2" ];

  sourceRoot = "${src.name}/UnixBench";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "-Wa,-q" ""

    substituteInPlace src/syscall.c \
      --replace-fail @coreutils@ "${coreutils}"
  '';

  nativeBuildInputs = [
    makeWrapper
    pandoc
    installShellFiles
  ];

  buildInputs = [
    perl
  ]
  ++ lib.optionals withGL [
    libx11
    libxext
    libGLX
  ];

  runtimeDependencies = [
    coreutils
    unixtools.net-tools
    unixtools.locale
    targetPackages.stdenv.cc
    gnugrep
    gawk
  ]
  ++ lib.optionals withX11perf [
    x11perf
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.optionals withGL [
    "GRAPHIC_TESTS=defined"
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,libexec,share}
    install -D Run $out/bin/ubench
    cp -r pgms $out/libexec/
    cp -r testdir $out/share/
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace USAGE \
      --replace-fail 'Run"' 'ubench"' \
      --replace-fail './Run' 'ubench' \
      --replace-fail 'Run ' 'ubench '
    pandoc -f rst -t man USAGE -o ubench.1
    installManPage ubench.1
  '';

  preFixup = ''
    substituteInPlace $out/libexec/pgms/multi.sh \
      --replace-fail '/bin/sh "$' '${runtimeShell} "$'

    substituteInPlace $out/bin/ubench \
      --subst-var out

    wrapProgram $out/bin/ubench \
      --prefix PATH : ${lib.makeBinPath runtimeDependencies}
  '';

  meta = {
    description = "Basic indicator of the performance of a Unix-like system";
    homepage = "https://github.com/kdlucas/byte-unixbench";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ubench";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
