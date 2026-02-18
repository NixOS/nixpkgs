{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  openssh,
}:
buildGoModule (finalAttrs: {
  pname = "zrepl";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "zrepl";
    repo = "zrepl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D2ADK1mX6Aq0I2fBeNLZeJ0GdxWxi2ApiZqT4b72yf4=";
  };

  vendorHash = "sha256-yu/bKkcWhHJSQPU2F4C58RC7geVTVEcXHlV0DRn/sUs=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zrepl/zrepl/version.zreplVersion=${finalAttrs.version}"
  ];

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute dist/systemd/zrepl.service $out/lib/systemd/system/zrepl.service \
      --replace /usr/local/bin/zrepl $out/bin/zrepl

    wrapProgram $out/bin/zrepl \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  passthru.tests = {
    inherit (nixosTests) zrepl;
  };

  meta = {
    homepage = "https://zrepl.github.io/";
    changelog = "https://github.com/zrepl/zrepl/releases/tag/${finalAttrs.src.tag}";
    description = "One-stop, integrated solution for ZFS replication";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cole-h
      mdlayher
    ];
    mainProgram = "zrepl";
  };
})
