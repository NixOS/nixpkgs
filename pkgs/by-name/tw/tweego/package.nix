{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tweego";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "tmedwards";
    repo = "tweego";
    rev = "v${version}";
    hash = "sha256-LE85mSByTz7uFjs0XtrpfD7OARoMPE56FpjFw+FlGYw=";
  };

  proxyVendor = true;
  vendorHash = "sha256-1O27CiCXgrD0RC+3jrVxAiq/RnI2s1FW2/uoBAd1fF8=";

  preBuild = ''
    go mod tidy
  '';

  meta = {
    description = "Free (gratis and libre) command line compiler for Twine/Twee story formats, written in Go";
    homepage = "https://www.motoslave.net/tweego";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ chrispwill ];
    mainProgram = "tweego";
  };
}
