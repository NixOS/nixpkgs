{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "entt";
  version = "3.10.3";

  src = fetchFromGitHub {
    owner = "skypjack";
    repo = "entt";
    rev = "v${version}";
    sha256 = "sha256-pewAwvNRCBS6rm3AmHthiayGfP71lqkAO+x6rT957Xg=";
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
