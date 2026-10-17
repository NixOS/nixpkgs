{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u-config";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "u-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Af7M/dHLINqp3Ef6C7pj7Jy+DI49PtdmQmB7s/HZ9zM=";
  };

  makeFlags = [
    "CROSS=${stdenv.cc.targetPrefix}"
    "CC=${lib.getExe stdenv.cc}"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildFlags = [ "pkg-config" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 pkg-config -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Smaller, simpler, portable pkg-config clone";
    homepage = "https://github.com/skeeto/u-config";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
})
