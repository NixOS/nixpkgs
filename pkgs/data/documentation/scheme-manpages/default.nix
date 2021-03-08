{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "scheme-manpages-unstable";
  version = "2020-08-14";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "2e99a0aea9c0327e3c2dcfb9b7a2f8f528b4fe43";
    sha256 = "0ykj4i8mx50mgyz9q63glfnc0mw1lf89hwsflpnbizjda5b4s0fp";
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
