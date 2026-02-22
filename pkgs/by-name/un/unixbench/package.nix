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

stdenv.mkDerivation (finalAttrs: {
  pname = "unixbench";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "kdlucas";
    repo = "byte-unixbench";
    rev = "a07fcc03264915c624f0e4818993c5b4df3fa703";
    hash = "sha256-gmRWAqE9/HBb0S9rK0DXoaCoiGbtat0gmdeozhbv0NI=";
  };

  patches = [
    ./common.patch
  ];

  patchFlags = [ "-p2" ];

  sourceRoot = "${finalAttrs.src.name}/UnixBench";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-Wa,-q" ""
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
      --replace 'Run"' 'ubench"' \
      --replace './Run' 'ubench' \
      --replace 'Run ' 'ubench '
    pandoc -f rst -t man USAGE -o ubench.1
    installManPage ubench.1
  '';

  preFixup = ''
    substituteInPlace $out/libexec/pgms/multi.sh \
      --replace '/bin/sh "$' '${runtimeShell} "$'

    substituteInPlace $out/bin/ubench \
      --subst-var out

    wrapProgram $out/bin/ubench \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDependencies}
  '';

  meta = {
    description = "Basic indicator of the performance of a Unix-like system";
    homepage = "https://github.com/kdlucas/byte-unixbench";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ubench";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
