{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "entt";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "skypjack";
    repo = "entt";
    rev = "v${version}";
    sha256 = "sha256-t1QRqasb82W277XEV2FG5JrsQWIWZ0G5V7wLI+p4MpQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/skypjack/entt";
    description = "A header-only, tiny and easy to use library for game programming and much more written in modern C++";
    maintainers = with maintainers; [ twey ];
    license = licenses.mit;
  };
}
