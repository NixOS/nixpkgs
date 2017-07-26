{ stdenv, fetchFromGitHub, nix, boehmgc }:
let version = "2.0.7"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "1q4ydp2w114wbfm41m4qgrabha7ifa17xyz5dr137vvnj6njp4vs";
  };

  buildFlags = [ "NIX_INCLUDE=${nix.dev}/include" "GC_INCLUDE=${boehmgc.dev}/include" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = https://github.com/shlevy/nix-plugins;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
