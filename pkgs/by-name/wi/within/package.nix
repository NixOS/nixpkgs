{
  fetchFromGitHub,
  lib,
  stdenv,
}: let
  pname = "within";
  version = "1.1.4";
  homepage = "https://github.com/sjmulder/within";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "sjmulder";
      repo = pname;
      tag = version;
      sha256 = "sha256-UyOgEe07K1LW5IbB7ngxelp+9Njq/NPPkWw3sxAQyVY=";
    };

    makeFlags = ["PREFIX=$(out)"];

    meta = {
      inherit homepage;
      description = "Run a command in other directories";
      changelog = "${homepage}/releases/tag/${version}";
      license = lib.licenses.bsd2;
      maintainers = [lib.maintainers.examosa];
      platforms = lib.platforms.all;
      mainProgram = pname;
    };
  }
