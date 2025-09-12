{
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
}:
let
  version = "14.2.0";
  src = fetchFromGitHub {
    owner = "jhaals";
    repo = "yopass";
    tag = version;
    hash = "sha256-cctouzn2HGV08Ytns2ZzvbnIj88/GRnUio2vHzeS3nA=";
  };

  website = callPackage ./website.nix { inherit src version; };
in
buildGoModule (finalAttrs: {
  inherit version src;
  pname = "yopass";

  vendorHash = "sha256-U+P6Ioj1hXWtlUtCbG8gD9ORugkJMbqWeXSC1pPmMig=";

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
