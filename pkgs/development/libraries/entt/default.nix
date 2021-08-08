{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "entt";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "skypjack";
    repo = "entt";
    rev = "v${version}";
    sha256 = "sha256-gieft0sErTr3aB6mZLdALSx+RkmCQuE9lopAwJbOXnA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/skypjack/entt";
    description = "A header-only, tiny and easy to use library for game programming and much more written in modern C++";
    maintainers = with maintainers; [ twey ];
    license = licenses.mit;
  };
}
