{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "windscribe-wstunnel";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "Windscribe";
    repo = "wstunnel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m1vy6yQKE4PSAcYRvHIz0f3Mc08NB9OdZwhB0zk0LjA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  proxyVendor = true;
  vendorHash = "sha256-EChb+QiY4A1/XUnjCx9gAdrsNaSwiJ1r55gY/W74F5s=";
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/wstunnel $out/bin/windscribe-wstunnel
  '';

  meta = {
    license = lib.licenses.gpl3Only;
    description = "Tunnel proxy to wrap OpenVPN TCP traffic in to websocket or regular TCP traffic as a means to bypass OpenVPN blocks.";
    homepage = "https://github.com/Windscribe/wstunnel";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    mainProgram = "windscribe-wstunnel";
  };
})
