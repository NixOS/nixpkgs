{ stdenv, fetchurl, perl, ghcWithPackages }:

let ghc = ghcWithPackages (hpkgs: with hpkgs; [
            binary zlib utf8-string readline fgl regex-compat HsSyck random
          ]);
in

stdenv.mkDerivation rec {
  name = "jhc-${version}";
  version = "0.8.2";

  src = fetchurl {
    url    = "http://repetae.net/dist/${name}.tar.gz";
    sha256 = "0lrgg698mx6xlrqcylba9z4g1f053chrzc92ri881dmb1knf83bz";
  };

  buildInputs = [ perl ghc ];

  meta = {
    description = "Whole-program, globally optimizing Haskell compiler";
    homepage = "http://repetae.net/computer/jhc/";
    license = stdenv.lib.licenses.bsd3;
    platforms = ["x86_64-linux"]; # 32 bit builds are broken
    maintainers = with stdenv.lib.maintainers; [ aforemny thoughtpolice ];
  };
}
