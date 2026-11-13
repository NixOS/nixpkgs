{
  lib,
  stdenv,
  fetchFromGitHub,
  docutils,
  bison,
  flex,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xxdiff";
  version = "5.1-unstable-2025-03-21";

  src = fetchFromGitHub {
    owner = "blais";
    repo = "xxdiff";
    rev = "a5593c1c675fb79d0ec2b6e353abba1fb0179aa7";
    hash = "sha256-nRXvqhO128XsAFy4KrsrSYKpzWnciXGJV6QkuqRa07w=";
  };

  nativeBuildInputs = [
    bison
    docutils
    flex
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [ libsForQt5.qtbase ];

  dontUseQmakeConfigure = true;

  # c++11 and above is needed for building with Qt 5.9+
  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    substituteInPlace xxdiff.pro \
      --replace-fail "../bin" "./bin"
  '';

  preConfigure = ''
    make -f Makefile.bootstrap
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin ./bin/xxdiff
    install -Dm444 -t $out/share/doc/xxdiff ${finalAttrs.src}/README.rst

    runHook postInstall
  '';

  meta = {
    description = "Graphical file and directories comparator and merge tool";
    mainProgram = "xxdiff";
    homepage = "http://furius.ca/xxdiff/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pSub
      raskin
    ];
    platforms = lib.platforms.linux;
  };
})
