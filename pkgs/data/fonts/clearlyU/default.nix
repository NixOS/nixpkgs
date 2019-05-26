{ stdenv, fetchurl, mkfontdir, mkfontscale }:

stdenv.mkDerivation {
  name = "clearlyU-12-1.9";

  src = fetchurl {
    url = https://www.math.nmsu.edu/~mleisher/Software/cu/cu12-1.9.tgz;
    sha256 = "1xn14jbv3m1khy7ydvad9ydkn7yygdbhjy9wm1v000jzjwr3lv21";
  };

  nativeBuildInputs = [ mkfontdir mkfontscale ];

  installPhase = ''
    mkdir -p $out/share/fonts
    cp *.bdf $out/share/fonts
    cd $out/share/fonts
    mkfontdir
    mkfontscale
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "127zrg65s90ksj99kr9hxny40rbxvpai62mf5nqk853hcd1bzpr6";

  meta = {
    description = "A Unicode font";
    maintainers = [stdenv.lib.maintainers.raskin];
  };
}
