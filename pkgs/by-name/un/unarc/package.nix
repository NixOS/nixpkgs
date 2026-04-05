{
  stdenv,
  unstableGitUpdater,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation {
  pname = "unarc";
  version = "0-unstable-2020-06-05";

  src = fetchFromGitHub {
    owner = "xredor";
    repo = "unarc";
    rev = "adc333d6cdd76d72da254cc80d766fbbcc683c95";
    hash = "sha256-ysOei44P3K+aA+h73DuHlgwTKqQx/Xq8z+DefB6Qhcs=";
  };

  postPatch = ''
    substituteInPlace 'CUI.h' \
      --replace-fail 'fgets(answer, 256, stdin);' 'if (!fgets (answer, 256, stdin)) return FALSE;' \
      --replace-fail 'printf (help)' 'printf ("%s", help)'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 unarc $out/bin

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Unpacker for ArC (FreeArc) archives ('ArC\\1' header)";
    homepage = "https://github.com/xredor/unarc";
    license = lib.licenses.unfree; # unknown
    maintainers = [ lib.maintainers.lucasew ];
    mainProgram = "unarc";
  };
}
