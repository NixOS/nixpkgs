{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "xan";
  version = "0.46.2";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = version;
    hash = "sha256-scLpmKlMIqBScvtMcrNnU0UPEJ8ufOefksk/kVQzZhE=";
  };

  cargoHash = "sha256-aTDT3kMSEjOzbjEez5i13D8HsnP1ZYBt6GkorR1EZiM=";
  useFetchCargoVendor = true;

  # FIXME: tests fail and I do not have the time to investigate. Temporarily disable
  # tests so that we can manually run and test the package for packaging purposes.
  doCheck = false;

  meta = {
    description = "Command line tool to process CSV files directly from the shell";
    homepage = "https://github.com/medialab/xan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "xan";
  };
}
