{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u-config";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "u-config";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-r1zcXKLqw/gK+9k3SX7OCBaZhvV2ya5VC9O3h+WdkyY=";
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
