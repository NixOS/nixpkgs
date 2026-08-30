{
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  lib,
}:
let
  version = "14.9.0";
  src = fetchFromGitHub {
    owner = "jhaals";
    repo = "yopass";
    tag = version;
    hash = "sha256-QGa6T0XNQaYIKyhGSnBNMjEaJk9JgEldxdv974lMtBU=";
  };

  website = callPackage ./website.nix { inherit src version; };
in
buildGoModule (finalAttrs: {
  inherit version src;
  pname = "yopass";

  __structuredAttrs = true;
  strictDeps = true;

  vendorHash = "sha256-CFo/rI6M7pbjVK0AtL92UyehNgobfWkw61tDNvqpCLY=";

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
    maintainers = with lib.maintainers; [
      ivarmedi
      fraggerfox
    ];
    mainProgram = "yopass";
    platforms = lib.platforms.unix;
  };
})
