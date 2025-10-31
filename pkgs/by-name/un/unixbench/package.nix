{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  pandoc,
  installShellFiles,
  perl,
  xorg,
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
    xorg.libX11
    xorg.libXext
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
    xorg.x11perf
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.optionals withGL [
    "GRAPHIC_TESTS=defined"
  ];

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

  meta = with lib; {
    description = "Basic indicator of the performance of a Unix-like system";
    homepage = "https://github.com/kdlucas/byte-unixbench";
    license = licenses.gpl2Plus;
    mainProgram = "ubench";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
