{
  lib,
  fetchFromGitHub,
  buildGoLatestModule,
  libwebp,
  nix-update-script,
}:
buildGoLatestModule (finalAttrs: {
  pname = "tronbyt-server";
  version = "2.2.3";
  buildInputs = [ libwebp ];
  postInstall = ''
    mv $out/bin/server $out/bin/tronbyt-server
  '';
  ldflags = [
    "-X 'tronbyt-server/internal/version.Version=v${finalAttrs.version}'"
    "-X 'tronbyt-server/internal/version.Commit=v${finalAttrs.version}'"
  ];
  subPackages = [ "cmd/server" ];
  src = fetchFromGitHub {
    owner = "tronbyt";
    repo = "server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uAOwI553F3YzJk7rwoZec/F2kD29kvcL5t44eORyFJw=";
  };
  vendorHash = "sha256-+/JPI6RqxfSbR9SIQuEvMMc2k8gSVZvMIlU/MnC2WmA=";

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Tronbyt server -- an alternate self hosted server for Tidbyt compatible devices";
    license = lib.licenses.asl20;
    homepage = "https://github.com/tronbyt/server";
    maintainers = [ lib.maintainers.laksith19 ];
    mainProgram = "tronbyt-server";
    platforms = lib.platforms.unix;
  };
})
