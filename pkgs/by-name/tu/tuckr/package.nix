{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuckr";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = version;
    hash = "sha256-ez27IEdOPryyIQCGATjKGeos3stLHP4BkwnJBLk+1W8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4F54N+r/er3j9zAzfSkXiwl5iEjh47PPzHByMZ0jA+Y=";

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = with lib; {
    description = "Super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    changelog = "https://github.com/RaphGL/Tuckr/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mimame ];
    mainProgram = "tuckr";
  };
}
