{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule rec {
  pname = "wgephemeralpeer";
  version = "1.0.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "wgephemeralpeer";
    rev = "v${version}";
    hash = "sha256-Dut6XnWWjtrmuuCxqwdLN4rnicXp1+MgZLkmmnCaZUc=";
  };

  vendorHash = null;

  meta = {
    description = "Mullvad Post-Quantum-secure WireGuard tunnels for vanilla WireGuard and custom integrations";
    homepage = "https://github.com/mullvad/wgephemeralpeer";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ EchoDelfino ];
  };
}
