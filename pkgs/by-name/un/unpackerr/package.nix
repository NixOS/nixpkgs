{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "unpackerr";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-npq0CXsaWaFa6RazQXRKVaqTyK87VhzaF/hd/d952Po=";
  };

  vendorHash = "sha256-v0ml1dTIhf79mhlyTrPNhIfg1Yhao27eP0pnI95OvaU=";

  ldflags = [
    "-s"
    "-w"
    "-X golift.io/version.Branch=main"
    "-X golift.io/version.Version=${finalAttrs.version}"
    "-X golift.io/version.Revision=v${finalAttrs.version}"
  ];

  meta = {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://unpackerr.zip/";
    maintainers = [ ];
    license = lib.licenses.mit;
    mainProgram = "unpackerr";
  };
})
