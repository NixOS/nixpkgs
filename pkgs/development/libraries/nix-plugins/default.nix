{ stdenv, fetchFromGitHub, nix }:
let version = "2.0.3"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "033w4m9ah127sfls7zqzpp2b1wdzsvzzk3bnkv6jyi31bws7hadp";
  };

  buildInputs = [ nix ];

  buildFlags = [ "NIX_INCLUDE=${nix.dev}/include" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = https://github.com/shlevy/nix-plugins;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
