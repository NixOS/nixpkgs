{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "xkblayout-state";
  version = "1b";

  src = fetchFromGitHub {
    owner = "nonpop";
    repo = "xkblayout-state";
    rev = "v${version}";
    sha256 = "sha256-diorqwDEBdzcBteKvhRisQaY3bx5seaOaWSaPwBkWDo=";
  };

  buildInputs = [ libX11 ];

  installPhase = ''
    mkdir -p $out/bin
    cp xkblayout-state $out/bin
  '';

  meta = {
    description = "Small command-line program to get/set the current XKB keyboard layout";
    homepage = "https://github.com/nonpop/xkblayout-state";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.jagajaga ];
    platforms = lib.platforms.linux;
    mainProgram = "xkblayout-state";
  };
}
