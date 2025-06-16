{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "zerotier-systemd-manager";
  version = "0.4.0"; # Adjust accordingly

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "zerotier-systemd-manager";
    rev = "v${version}";
    sha256 = "sha256-vq6AqrA9ryzLcLEsPD2KbBZhF5YjF48ErIWb8e3b9JI=";
  };

  vendorHash = "sha256-40e/FFzHbWo0+bZoHQWzM7D60VUEr+ipxc5Tl0X9E2A=";

  meta = with lib; {
    description = "Get ZeroTier playing nice with systemd-networkd and resolvectl";
    homepage = "https://github.com/zerotier/zerotier-systemd-manager";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      x-zvf
    ];
    platforms = platforms.linux;
  };
}
