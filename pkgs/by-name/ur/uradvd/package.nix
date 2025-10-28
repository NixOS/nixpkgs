{
  stdenv,
  lib,
  fetchFromGitHub,
  gitMinimal,
  uradvd,
  versionCheckHook,
}:

stdenv.mkDerivation {
  pname = "uradvd";
  version = "r26-1e64364d";

  src = fetchFromGitHub {
    owner = "freifunk-gluon";
    repo = "uradvd";
    rev = "1e64364d323acb8c71285a6fb85d384334e7007d";
    deepClone = true;
    hash = "sha256-+MDhBuCPJ/dcKw4/z4PnXXGoNomIz/0QI32XfLR6fK0=";
  };

  nativeBuildInputs = [
    gitMinimal
  ];

  installPhase = ''
    runHook preInstall

    install -D --mode=0755 uradvd -t "$out/bin"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Tiny IPv6 Router Advertisement Daemon";
    homepage = "https://github.com/freifunk-gluon/uradvd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "uradvd";
  };
}
