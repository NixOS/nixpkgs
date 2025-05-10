{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    rev = "v${version}";
    hash = "sha256-TI9lveFJsb/OgGQRiPW5iuatB8dsc7yxBs1rb148nEY=";
  };

  # no such file or directory errors
  doCheck = false;

  useFetchCargoVendor = true;
  cargoHash = "sha256-9cNu0cgoo0/41daJwy/uWIXa2wFhYkcPhJfA/69DVx0=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
