{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tidy-viewer";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "alexhallam";
    repo = "tv";
    rev = version;
    sha256 = "sha256-OnvRiQ5H/Vsmfu+F1i68TowjrDwQLQtV1sC6Jrp4xA4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-k/8crmGkFOLcakL5roYrSBVoYyGMELh1Mu/X6SlUeds=";

  meta = with lib; {
    description = "Cross-platform CLI csv pretty printer that uses column styling to maximize viewer enjoyment";
    mainProgram = "tidy-viewer";
    homepage = "https://github.com/alexhallam/tv";
    changelog = "https://github.com/alexhallam/tv/blob/${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ figsoda ];
  };
}
