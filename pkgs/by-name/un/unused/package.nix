{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
}:
rustPlatform.buildRustPackage rec {
  pname = "unused";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "unused-code";
    repo = pname;
    rev = version;
    sha256 = "sha256-+1M8dUfjjrT4llS0C6WYDyNxJ9QZ5s9v+W185TbgwMw=";
  };

  nativeBuildInputs = [ cmake ];

  cargoHash = "sha256-hCtkR20+xs1UHZP7oJVpJACVGcMQLQmSS1QE2tmIVhs=";

  meta = {
    description = "Tool to identify potentially unused code";
    homepage = "https://unused.codes";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
