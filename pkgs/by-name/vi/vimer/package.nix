{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.2.0";
  pname = "vimer";

  src = fetchFromGitHub {
    owner = "susam";
    repo = "vimer";
    rev = finalAttrs.version;
    hash = "sha256-UcML7gjnplVqyQd+C+YWPl9nY0AsDV13V0srfuLIEAc=";
  };

  installPhase = ''
    mkdir $out/bin/ -p
    cp vimer $out/bin/
    chmod +x $out/bin/vimer
  '';

  meta = {
    homepage = "https://github.com/susam/vimer";
    description = ''
      A convenience wrapper for gvim/mvim --remote(-tab)-silent to open files
      in an existing instance of GVim or MacVim.
    '';
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = lib.platforms.all;
    mainProgram = "vimer";
  };

})
