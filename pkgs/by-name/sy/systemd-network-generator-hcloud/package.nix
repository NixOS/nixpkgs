{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

let
  version = "1.0";
in

buildGoModule {
  pname = "systemd-network-generator-hcloud";
  inherit version;

  src = fetchFromGitHub {
    owner = "stephank";
    repo = "systemd-network-generator-hcloud";
    rev = "v${version}";
    sha256 = "sha256-yzaEc0N7bXuZxqs4/D0pP6VNtVoMe2LwPGBjw5hzbXo=";
  };

  vendorHash = "sha256-l3uOzNt6e9gQvjXa/+rxfaLER2AOsWVXwgZgBqHzquU=";

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute \
      systemd-network-generator-hcloud.service.in \
      $out/lib/systemd/system/systemd-network-generator-hcloud.service \
      --replace-fail '{{LIBEXECDIR}}' "$out/bin"
  '';

  meta = with lib; {
    description = "Generate network units from Hetzner Cloud server metadata";
    homepage = "https://github.com/stephank/systemd-network-generator-hcloud";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ stephank ];
    platforms = lib.platforms.linux;
    mainProgram = "systemd-network-generator-hcloud";
  };
}
