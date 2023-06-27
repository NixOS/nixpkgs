{ lib, stdenv, fetchFromGitHub, fetchpatch, meson, ninja, nasm, xxd }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256 = "sha256-TkMy2tEdG1FPPWfH/wPnVbs5kocqe4Y0jU4yvbiRZ9k=";
  };

  sourceRoot = "source/libvmaf";

  patches = [
    # Backport fix for non-Linux, non-Darwin platforms.
    (fetchpatch {
      url = "https://github.com/Netflix/vmaf/commit/f47640f9ffee9494571bd7c9622e353660c93fc4.patch";
      stripLen = 1;
      sha256 = "rsTKuqp8VJG5DBDpixPke3LrdfjKzUO945i+iL0n7CY=";
    })
  ];

  nativeBuildInputs = [ meson ninja nasm xxd ];

  mesonFlags = [ "-Denable_avx512=true" ];

  outputs = [ "out" "dev" ];
  doCheck = false;

  meta = with lib; {
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    homepage = "https://github.com/Netflix/vmaf";
    changelog = "https://github.com/Netflix/vmaf/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd2Patent;
    maintainers = [ maintainers.cfsmp3 maintainers.marsam ];
    mainProgram = "vmaf";
    platforms = platforms.unix;
  };

}
