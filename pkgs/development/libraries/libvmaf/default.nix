{ stdenv, fetchFromGitHub, meson, ninja, nasm }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256 = "0x3l3g0hgrrjh3ygmxr1pd3rd5589s07c7id35nvj76ch5b7gy63";
  };

  sourceRoot = "source/libvmaf";

  nativeBuildInputs = [ meson ninja nasm ];
  outputs = [ "out" "dev" ];
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/Netflix/vmaf";
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    platforms = platforms.unix;
    license = licenses.bsd2Patent;
    maintainers = [ maintainers.cfsmp3 maintainers.marsam ];
  };

}
