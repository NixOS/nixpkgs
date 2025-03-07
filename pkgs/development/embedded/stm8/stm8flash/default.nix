{ lib, stdenv, fetchFromGitHub, libusb1, pkg-config }:

stdenv.mkDerivation rec {
  pname = "stm8flash";
  version = "2022-03-27";

  src = fetchFromGitHub {
    owner = "vdudouyt";
    repo = "stm8flash";
    rev = "23305ce5adbb509c5cb668df31b0fd6c8759639c";
    sha256 = "sha256-fFoC2EKSmYyW2lqrdAh5A2WEtUMCenKse2ySJdNHu6w=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  # NOTE: _FORTIFY_SOURCE requires compiling with optimization (-O)
  env.NIX_CFLAGS_COMPILE = "-O";

  preBuild = ''
    export DESTDIR=$out;
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  meta = with lib; {
    homepage = "https://github.com/vdudouyt/stm8flash";
    description = "Tool for flashing STM8 MCUs via ST-LINK (V1 and V2)";
    mainProgram = "stm8flash";
    maintainers = with maintainers; [ pkharvey ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
