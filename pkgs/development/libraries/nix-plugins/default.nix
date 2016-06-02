{ stdenv, fetchgit, nix }:

stdenv.mkDerivation {
  name = "nix-plugins-1.0.0";

  src = fetchgit {
    url = git://github.com/shlevy/nix-plugins.git;
    rev = "refs/tags/1.0.0";
    sha256 = "1w7l4mdwgf5w1g48mbng4lcg2nihixvp835mg2j7gghnya309fxl";
  };

  buildInputs = [ nix ];

  buildFlags = [ "NIX_INCLUDE=${nix}/include" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = https://github.com/shlevy/nix-plugins;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    broken = true;
  };
}
