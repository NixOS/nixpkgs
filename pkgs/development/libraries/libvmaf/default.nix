{ lib, stdenv, fetchFromGitHub, meson, ninja, nasm }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256 = "sha256-t1dK4UnperX9YtvmTwIo/03Dxq/Pl+K6kZIL0uX1OcE=";
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
