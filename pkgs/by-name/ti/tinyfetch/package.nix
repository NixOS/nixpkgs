{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "tinyfetch";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "abrik1";
    repo = "tinyfetch";
    rev = "refs/tags/${version}";
    hash = "sha256-I0OurcPKKZntZn7Bk9AnWdpSrU9olGp7kghdOajPDeQ=";
  };

  sourceRoot = "${src.name}/src";

  buildPhase = ''
    runHook preBuild
    $CC tinyfetch.c -o tinyfetch
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 tinyfetch -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Simple fetch in C which is tiny and fast";
    homepage = "https://github.com/abrik1/tinyfetch";
    license = lib.licenses.mit;
    mainProgram = "tinyfetch";
    maintainers = with lib.maintainers; [ pagedMov ];
    platforms = lib.platforms.unix;
  };
}
