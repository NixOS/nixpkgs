{ lib, stdenv, fetchurl,
  pkg-config, pure, haskellPackages }:

stdenv.mkDerivation rec {
  pname = "pure-gen";
  version = "0.20";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-gen-${version}.tar.gz";
    sha256 = "cfadd99a378b296325937d2492347611cc1e1d9f24594f91f3c2293eca01a4a8";
  };

  hsEnv = haskellPackages.ghcWithPackages (hsPkgs : [hsPkgs.language-c]);
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ hsEnv pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];

  meta = {
    description = "Pure interface generator";
    homepage = "http://puredocs.bitbucket.org/pure-gen.html";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    hydraPlatforms = [];
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
