{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libusb1,
}:

buildGoModule (finalAttrs: {
  pname = "wally-cli";
  version = "2.0.1";

  subPackages = [ "." ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally-cli";
    rev = "${finalAttrs.version}-linux";
    sha256 = "NuyQHEygy4LNqLtrpdwfCR+fNy3ZUxOClVdRen6AXMc=";
  };

  vendorHash = "sha256-HffgkuKmaOjTYi+jQ6vBlC50JqqbYiikURT6TCqL7e0=";

  meta = {
    description = "Tool to flash firmware to mechanical keyboards";
    mainProgram = "wally-cli";
    homepage = "https://ergodox-ez.com/pages/wally-planck";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      spacekookie
      r-burns
    ];
  };
})
