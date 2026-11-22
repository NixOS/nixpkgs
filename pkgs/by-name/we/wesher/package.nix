{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wesher";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "costela";
    repo = "wesher";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-EIajvcBhS5G9dJzRgXhnD1QKOAhmzngdyCU4L7itT8U=";
  };

  vendorHash = "sha256-BZzhBC4C0OoAxUEDROkggCQF35C9Z4+0/Jk0ZD8Hz1s=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Wireguard overlay mesh network manager";
    homepage = "https://github.com/costela/wesher";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
    mainProgram = "wesher";
  };
})
