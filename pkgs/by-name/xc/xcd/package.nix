{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcd";
  version = "1.2";

  src = fetchurl {
    url = "https://www.muppetlabs.com/~breadbox/pub/software/xcd-${finalAttrs.version}.tar.gz";
    sha256 = "1cgwspy08q05rhxbp7m1yrrix252i9jzfcfbzmhdvlgf5bfpl25g";
  };

  buildInputs = [ ncurses ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall
    install -D $pname $out/bin/$pname
    runHook postInstall
  '';

  meta = {
    description = "Colorized hexdump tool";
    homepage = "https://www.muppetlabs.com/~breadbox/software/xcd.html";
    maintainers = [ lib.maintainers.xfnw ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "xcd";
  };
})
