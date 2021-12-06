{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "zydis";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zydis";
    rev = "bfee99f49274a0eec3ffea16ede3a5bda9cda88f";
    sha256 = "0x2lpc33ynd0zzirdxp2lycvg3545wh1ssgy4qlv81471iwwzv6b";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-41253.patch";
      url = "https://github.com/zyantific/zydis/commit/330b259583ade789886ce11af2ebcd030097dcbf.patch";
      sha256 = "137lvqcm5fabv82f11c28skczb0hrmqh7i9a7hj2121p0nd729rr";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Fast and lightweight x86/x86-64 disassembler library";
    license = licenses.mit;
    maintainers = [ maintainers.jbcrail ];
    platforms = platforms.all;
  };
}
