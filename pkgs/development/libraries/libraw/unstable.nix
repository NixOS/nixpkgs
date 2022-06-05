{ libraw, fetchFromGitHub }:

libraw.overrideAttrs (_: rec {
  version = "unstable-2021-12-03";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = "52b2fc52e93a566e7e05eaa44cada58e3360b6ad";
    sha256 = "kW0R4iPuqnFuWYDrl46ok3kaPcGgY2MqZT7mqVX+BDQ=";
  };
})
