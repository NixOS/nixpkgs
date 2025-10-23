{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  python3,
  enableModTool ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "volk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9bURoGyjdNoKCcgGvZL9VygQqUQxOrwthp154Was2/s=";
    fetchSubmodules = true;
  };

  cmakeFlags = [ (lib.cmakeBool "ENABLE_MODTOOL" enableModTool) ];

  nativeBuildInputs = [
    cmake
    python3
    python3.pkgs.mako
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://libvolk.org/";
    description = "Vector Optimized Library of Kernels";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
})
