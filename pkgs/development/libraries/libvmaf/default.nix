{ stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256 = "18w0z3w90fdbzsqaa4diwvq0xmvg0aiw4hi3aaa4pq0zgnb8g3mk";
  };

  sourceRoot = "source/libvmaf";

  nativeBuildInputs = [ meson ninja ];
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
