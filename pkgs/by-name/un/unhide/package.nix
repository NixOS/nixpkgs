{
  cmake,
  fetchFromGitHub,
  fetchurl,
  iproute2,
  lib,
  lsof,
  nettools,
  pkg-config,
  procps,
  psmisc,
  stdenv,
}:

let
  makefile = fetchurl {
    url = "https://gitlab.archlinux.org/archlinux/packaging/packages/unhide/-/raw/27c25ad5e1c6123e89f1f35423a0d50742ae69e9/Makefile";
    hash = "sha256-bSo3EzpcsFmVvwyPgjCCDOJLbzNpxJ6Eptp2hNK7ZXk=";
  };
in
stdenv.mkDerivation rec {
  pname = "unhide";
  version = "20220611";

  src = fetchFromGitHub {
    owner = "YJesus";
    repo = "Unhide";
    rev = "v${version}";
    hash = "sha256-v4otbDhKKRLywH6aP+mbMR0olHbW+jk4TXTBY+iaxdo=";
  };

  postPatch = ''
    cp ${makefile} Makefile
  '';

  dontConfigure = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    iproute2
    lsof
    nettools
    procps
    psmisc
  ];

  meta = {
    description = "Forensic tool to find hidden processes and TCP/UDP ports by rootkits/LKMs";
    homepage = "https://github.com/YJesus/Unhide";
    changelog = "https://github.com/YJesus/Unhide/blob/${src.rev}/NEWS";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "unhide";
    platforms = lib.platforms.all;
  };
}
