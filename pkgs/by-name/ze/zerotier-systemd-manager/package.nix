{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "zerotier-systemd-manager";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "zerotier-systemd-manager";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vq6AqrA9ryzLcLEsPD2KbBZhF5YjF48ErIWb8e3b9JI=";
  };

  vendorHash = "sha256-40e/FFzHbWo0+bZoHQWzM7D60VUEr+ipxc5Tl0X9E2A=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Get ZeroTier playing nice with systemd-networkd and resolvectl";
    homepage = "https://github.com/zerotier/zerotier-systemd-manager";
    license = lib.licenses.bsd3;
    mainProgram = "zerotier-systemd-manager";
    maintainers = with lib.maintainers; [
      x-zvf
    ];
    platforms = lib.platforms.linux;
  };
})
