{ fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage {
  name = "uefisettings";
  version = "unstable-2024-02-20";

  src = fetchFromGitHub {
    owner = "linuxboot";
    repo = "uefisettings";
    rev = "eae8b8b622b7ac3c572eeb3b3513ed623e272fcc";
    hash = "sha256-zLgrxYBj5bEMZRw5sKWqKuV3jQOJ6dnzbzpoqE0OhKs=";
  };

  cargoHash = "sha256-FCQ/1E6SZyVOOAlpqyaDWEZx0y0Wk3Caosvr48VamAA=";

  # Tests expect filesystem access to directories like /proc
  doCheck = false;

  meta = with lib; {
    description = "CLI tool to read/get/extract and write/change/modify BIOS/UEFI settings.";
    homepage = "https://github.com/linuxboot/uefisettings";
    license = with licenses; [ bsd3 ];
    mainProgram = "uefisettings";
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
}
