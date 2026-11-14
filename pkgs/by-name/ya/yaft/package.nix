{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.2.9";
  pname = "yaft";

  outputs = [
    "out"
    "terminfo"
  ];

  src = fetchFromGitHub {
    owner = "uobikiemukot";
    repo = "yaft";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bbKA3dcaHqo5SKJGaaGaciBvq88GhUOJvbOQUjl6MVA=";
  };

  buildInputs = [ ncurses ];

  installFlags = [
    "PREFIX=$(out)"
    "MANPREFIX=$(out)/share/man"
  ];

  postInstall = ''
    mkdir -p $out/nix-support $terminfo/share
    mv $out/share/terminfo $terminfo/share/
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    homepage = "https://github.com/uobikiemukot/yaft";
    description = "Yet another framebuffer terminal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = with lib.platforms; linux;
  };
})
