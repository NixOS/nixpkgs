{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2022-05-14";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "e4d8e389312a865e350ef88f3e9d69be290705c7";
    sha256 = "sha256-bYg8XSycbQIaZDsE0G5Xy0bd2JNWHwYEnyL6ThN7XS4=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/man
    cp -r man3/ man7/ $out/share/man/
  '';

  meta = with lib; {
    description = "Unix manual pages for R6RS and R7RS";
    homepage = "https://github.com/schemedoc/manpages";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
