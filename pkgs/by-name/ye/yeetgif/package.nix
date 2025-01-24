{
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:

buildGoModule rec {
  pname = "yeetgif";
  version = "1.23.6";

  src = fetchFromGitHub {
    owner = "sgreben";
    repo = pname;
    rev = version;
    hash = "sha256-Z05GhtEPj3PLXpjF1wK8+pNUY3oDjbwZWQsYlTX14Rc=";
  };

  deleteVendor = true;
  vendorHash = "sha256-LhkOMCuYO4GHezk21SlI2dP1UPmBp4bv2SdNbUQMKsI=";

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/sgreben/yeetgif/commit/5d2067b9832898c2b1ac51bf6a5f107619038270.patch";
      hash = "sha256-3eyqbpPyuQHjAN5mjQyZo0xY6L683T5Ytyx02II/iU4=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "gif effects CLI. single binary, no dependencies. linux, osx, windows. #1 workplace productivity booster. #yeetgif #eggplant #golang";
    homepage = "https://github.com/sgreben/yeetgif";
    license = with licenses; [
      mit
      asl20
      cc-by-nc-sa-40
    ];
    maintainers = with maintainers; [ ajs124 ];
    mainProgram = "gif";
  };
}
