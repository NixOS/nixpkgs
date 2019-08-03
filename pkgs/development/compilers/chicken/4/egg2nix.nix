{ stdenv, eggDerivation, fetchurl, chickenEggs }:

# Note: This mostly reimplements the default.nix already contained in
# the tarball. Is there a nicer way than duplicating code?

let
  version = "0.5";
in
eggDerivation {
  src = fetchurl {
    url = "https://github.com/the-kenny/egg2nix/archive/${version}.tar.gz";
    sha256 = "0adal428v4i7h9lzs7sfq75q2mxhsbf1qqwzrsjv8j41paars20y";
  };

  name = "egg2nix-${version}";
  buildInputs = with chickenEggs; [
    matchable http-client
  ];

  meta = {
    description = "Generate nix-expression from CHICKEN scheme eggs";
    homepage = https://github.com/the-kenny/egg2nix;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
