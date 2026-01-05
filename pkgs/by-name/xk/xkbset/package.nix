{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkbset";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "stephenmontgomerysmith";
    repo = "xkbset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N2kD4XeBV09tzdBlHW/Y5ZK3xdr3aiszFtR6bvfTRvU=";
  };

  buildInputs = [
    perl
    libX11
  ];

  makeFlags = [ "X11PREFIX=${placeholder "out"}" ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
  '';

  postInstall = ''
    rm -f $out/bin/xkbset-gui
  '';

  meta = {
    homepage = "https://github.com/stephenmontgomerysmith/xkbset";
    description = "Program to help manage many of XKB features of X window";
    maintainers = with lib.maintainers; [ drets ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    mainProgram = "xkbset";
  };
})
