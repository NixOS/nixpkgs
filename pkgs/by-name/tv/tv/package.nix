{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tv";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "uzimaru0000";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qODv45smZ6jHCJBaa6EEvFLG+7g+FWrRf6BiHRFLzqM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pg8u+1C68ilg0uhszQnsN1bRbniJd39yQHujerQx+mI=";

  meta = with lib; {
    description = "Format json into table view";
    mainProgram = "tv";
    homepage = "https://github.com/uzimaru0000/tv";
    changelog = "https://github.com/uzimaru0000/tv/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
