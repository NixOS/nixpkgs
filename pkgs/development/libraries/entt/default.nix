{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "entt";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "skypjack";
    repo = "entt";
    rev = "v${version}";
    sha256 = "sha256-XaQQOt3UekjE4QUUW6+W5M4tkTqeGjZDExJB1U1/gJ8=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/skypjack/entt";
    description = "A header-only, tiny and easy to use library for game programming and much more written in modern C++";
    maintainers = with maintainers; [ twey ];
    license = licenses.mit;
  };
}
