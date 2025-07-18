{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yeahconsole";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = "yeahconsole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ea6erNF9hEhDHlWLctu1SHFVoXXXsPeWUbvCBSZwn4s=";
  };

  buildInputs = [
    libX11
    libXrandr
  ];

  preConfigure = ''
    sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" Makefile
  '';

  meta = {
    description = "Turns an xterm into a gamelike console";
    homepage = "https://github.com/jceb/yeahconsole";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ jceb ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
