{ stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256 = "10fw53k9k4aq4p2qi5qkfjfnhldw4p5bbmxggf8220gfa95nvyl3";
  };

  sourceRoot = "source/libvmaf";

  nativeBuildInputs = [ meson ninja ];
  outputs = [ "out" "dev" ];
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/Netflix/vmaf";
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = [ maintainers.cfsmp3 maintainers.marsam ];
  };

}
