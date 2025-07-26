{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "vrml2scad";
  version = "2023-02-06";

  src = fetchFromGitHub {
    owner = "agausmann";
    repo = "vrml2scad";
    rev = "52f47732e9f8c155d2d300c1e6d7d57f83bff744";
    hash = "sha256-/U3hyL+z6CxCO872c+160MJ4k6yZSkZDrk4rGgTG8Vc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-O8/bGF0XYQfXCnafwTa4Wmx1mKbRgebIBYxFTyQzYeA=";

  meta = {
    description = "Translate VRML / WRL files to an OpenSCAD script";
    homepage = "https://github.com/agausmann/vrml2scad";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "vrml2scad";
  };
}
