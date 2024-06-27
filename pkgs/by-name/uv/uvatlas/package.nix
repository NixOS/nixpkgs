{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  directxmath,
  directx-headers,
}:

stdenv.mkDerivation rec {
  pname = "uvatlas";
  version = "2024.06";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "UVAtlas";
    rev = "jun2024";
    hash = "sha256-2rnhs/1yUd187+W8A3GoHZ5z7W5lxo7Y35rCg5Vgflc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    directxmath
    directx-headers
  ];

  meta = {
    description = "UVAtlas isochart texture atlas";
    homepage = "https://github.com/Microsoft/UVAtlas";
    changelog = "https://github.com/Microsoft/UVAtlas/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "uvatlas";
    platforms = lib.platforms.all;
  };
}
