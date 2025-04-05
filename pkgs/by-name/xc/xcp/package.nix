{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    rev = "v${version}";
    hash = "sha256-tAECD3gNx6RDzEJhGt2nrykxHfh4S1qJKt9yNdZpuGs=";
  };

  # no such file or directory errors
  doCheck = false;

  useFetchCargoVendor = true;
  cargoHash = "sha256-plWq+p6NqOjonkdsGAL7hHBwVzFtkkgTNWNKEOBNZeU=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
