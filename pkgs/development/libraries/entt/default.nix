{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "entt";
  version = "3.12.2";

  src = fetchFromGitHub {
    owner = "skypjack";
    repo = "entt";
    rev = "v${version}";
    sha256 = "sha256-gzoea3IbmpkIZYrfTZA6YgcnDU5EKdXF5Y7Yz2Uaj4A=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/skypjack/entt";
    description = "A header-only, tiny and easy to use library for game programming and much more written in modern C++";
    maintainers = with maintainers; [ twey ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
