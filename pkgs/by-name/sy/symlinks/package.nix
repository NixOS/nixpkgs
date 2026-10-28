{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "symlinks";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "brandt";
    repo = "symlinks";
    rev = "v${finalAttrs.version}";
    sha256 = "EMWd7T/k4v1uvXe2QxhyPoQKUpKIUANE9AOwX461FgU=";
  };

  buildFlags = [ "CC=${stdenv.cc}/bin/cc" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man8
    cp symlinks $out/bin
    cp symlinks.8 $out/share/man/man8
  '';

  meta = {
    description = "Find and remedy problematic symbolic links on a system";
    homepage = "https://github.com/brandt/symlinks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ckauhaus ];
    platforms = lib.platforms.unix;
    mainProgram = "symlinks";
  };
})
