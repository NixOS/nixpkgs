{ lib, stdenv, fetchFromGitHub, meson, ninja, nasm }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256 = "0dynk1pmsyf23vfxljaazqkr27vfrvhj3dyjzm06zxpzsn59aif3";
  };

  sourceRoot = "source/libvmaf";

  nativeBuildInputs = [ meson ninja nasm ];

  mesonFlags = [ "-Denable_avx512=true" ];

  outputs = [ "out" "dev" ];
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Netflix/vmaf";
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    changelog = "https://github.com/Netflix/vmaf/blob/v${version}/CHANGELOG.md";
    platforms = platforms.unix;
    license = licenses.bsd2Patent;
    maintainers = [ maintainers.cfsmp3 maintainers.marsam ];
  };

}
