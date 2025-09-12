{
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
}:
let
  version = "12.4.0";
  src = fetchFromGitHub {
    owner = "jhaals";
    repo = "yopass";
    tag = version;
    hash = "sha256-rpPwMALKgU1N982icphtVeQhYouMyAYD0LMyZxv0+9M=";
  };

  website = callPackage ./website.nix { inherit src version; };
in
buildGoModule (finalAttrs: {
  inherit version src;
  pname = "yopass";

  vendorHash = "sha256-7jOaw60hzZwtJkntagz+H4IjFUqrUcCNL1rkWDqQRuU=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  subPackages = [
    "cmd/yopass"
    "cmd/yopass-server"
  ];

  checkFlags = [
    # Disable tests that require network access
    "-skip=TestSecretNotFoundError"
  ];

  postInstall = ''
    wrapProgram $out/bin/yopass-server \
      --add-flags "--asset-path ${website}"
  '';

  meta = {
    description = "Secure sharing of secrets, passwords and files";
    homepage = "https://github.com/jhaals/yopass";
    changelog = "https://github.com/jhaals/yopass/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ivarmedi ];
    mainProgram = "yopass";
    platforms = lib.platforms.unix;
  };
})
