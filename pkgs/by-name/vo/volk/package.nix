{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  python3,
  enableModTool ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "volk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R1FT5sbl0fAAl6YIX5aD5CiQ/AjZkCSDPPQPiuy4WBY=";
    fetchSubmodules = true;
  };
  patches = [
    # https://github.com/gnuradio/volk/pull/766
    (fetchpatch {
      url = "https://github.com/gnuradio/volk/commit/e46771a739658b5483c25ee1203587bf07468c4d.patch";
      hash = "sha256-33V6lA4Ch50o2E7HPUMQ2NPqHXx/i6FUbz3vIaQa9Wc=";
    })
  ];

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
