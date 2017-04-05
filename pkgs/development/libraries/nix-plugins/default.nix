{ stdenv, fetchFromGitHub, nix, boehmgc }:
let version = "2.0.6"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "0gbajaxg7awk1fhicsnmvhrmd47wc7i38lz4baxks17sgx76amqr";
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
