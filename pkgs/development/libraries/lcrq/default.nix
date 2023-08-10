{
  stdenv,
  fetchFromGitea,
  lib,
  ...
}:
stdenv.mkDerivation rec {
  name = "lcrq";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecast";
    repo = "lcrq";
    rev = "v${version}";
    sha256 = "sha256-s8+uTF6GQ76wG1zoAxqCaVT1J5Rd7vxPKX4zbQx6ro4=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://librecast.net/lcrq.html";
    changelog = "https://codeberg.org/librecast/lcrq/src/tag/v${version}/CHANGELOG.md";
    description = "Librecast RaptorQ library.";
    license = [ licenses.gpl2 licenses.gpl3 ];
    maintainers = with maintainers; [
      albertchae
      aynish
      DMills27
      jasonodoom
      jleightcap
    ];
    platforms = lib.platforms.unix;
  };
}
