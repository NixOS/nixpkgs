{ stdenv, fetchgit, nix }:

stdenv.mkDerivation {
  name = "nix-plugins-1.0.0";

  src = fetchgit {
    url = git://github.com/shlevy/nix-plugins.git;
    rev = "refs/tags/1.0.0";
    sha256 = "e624de55cabc9014e77f21978d657089ae94ce161584b3d9dc3c9763658421b3";
  };

  buildInputs = [ nix ];

  buildFlags = [ "NIX_INCLUDE=${nix}/include" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = https://github.com/shlevy/nix-plugins;
    license = stdenv.lib.licenses.mit;
    maintaners = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.all;
  };
}
