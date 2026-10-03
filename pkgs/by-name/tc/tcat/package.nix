{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tcat";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "rsc";
    repo = "tcat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QdDzzp09CNNm3L94EPW+v3lo0H3MuhnlQzR13ct3/+s=";
  };
  vendorHash = null;
  subPackages = ".";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Table cat";
    homepage = "https://github.com/rsc/tcat";
    maintainers = [
      lib.maintainers.mmlb
    ];
    license = lib.licenses.bsd3;
    mainProgram = "tcat";
  };
})
