{ stdenv, fetchFromGitHub, nix }:
let version = "2.0.2"; in
stdenv.mkDerivation {
  name = "nix-plugins-${version}";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
    sha256 = "02bi0p9qjpyxzbr0ki9q774lwdjwcpipkzx84xx9q1ywwafjhr7b";
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
