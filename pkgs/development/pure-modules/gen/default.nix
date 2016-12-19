{ lib, stdenv, fetchurl,
  pkgconfig, pure, haskellPackages }:

stdenv.mkDerivation rec {
  baseName = "gen";
  version = "0.20";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "cfadd99a378b296325937d2492347611cc1e1d9f24594f91f3c2293eca01a4a8";
  };

  hsEnv = haskellPackages.ghcWithPackages (hsPkgs : [hsPkgs.language-c]);
  buildInputs = [ pkgconfig hsEnv pure ];
  makeFlags = "libdir=$(out)/lib prefix=$(out)/";

  meta = {
    description = "Pure interface generator";
    homepage = http://puredocs.bitbucket.org/pure-gen.html;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
