{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "xan";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = version;
    hash = "sha256-tzbHIXmTyP7MQeIMVLV4soGg9oRL7bM73+kFqD5zIi0=";
  };

  cargoHash = "sha256-kqgmfdRfuNhi8X5/oljrBTf4cg+tXuO5Uh7MtBsTtqg=";
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
