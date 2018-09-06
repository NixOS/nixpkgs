# Updating the dependencies for this package:
#
#   wget https://github.com/mint-lang/mint/blob/0.2.1/shard.lock
#   nix-shell -p crystal libyaml --run 'crystal run crystal2nix.cr'
#
{stdenv, lib, fetchFromGitHub, crystal, zlib, openssl, duktape, which }:
let
  crystalPackages = lib.mapAttrs (name: src:
    stdenv.mkDerivation {
      name = lib.replaceStrings ["/"] ["-"] name;
      src = fetchFromGitHub src;
      phases = "installPhase";
      installPhase = ''cp -r $src $out'';
      passthru = { libName = name; };
    }
  ) (import ./shards.nix);

  crystalLib = stdenv.mkDerivation {
    name = "crystal-lib";
    src = lib.attrValues crystalPackages;
    libNames = lib.mapAttrsToList (k: v: [k v]) crystalPackages;
    phases = "buildPhase";
    buildPhase = ''
      mkdir -p $out
      linkup () {
        while [ "$#" -gt 0 ]; do
          ln -s $2 $out/$1
          shift; shift
        done
      }
      linkup $libNames
    '';
  };
in
stdenv.mkDerivation rec {
  version = "0.2.1";
  name = "mint-${version}";
  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    sha256 = "0r8hv2j5yz0rlvrbpnybihj44562pkmsssa8f0hjs45m1ifvf4b1";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ crystal zlib openssl duktape ];

  buildPhase = ''
    mkdir -p $out/bin tmp
    cd tmp
    ln -s ${crystalLib} lib
    cp -r $src/* .
    crystal build src/mint.cr -o $out/bin/mint --verbose --progress --release --no-debug
  '';

  installPhase = ''true'';

  meta = {
    description = "A refreshing language for the front-end web";
    homepage = https://mint-lang.com/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ manveru ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
