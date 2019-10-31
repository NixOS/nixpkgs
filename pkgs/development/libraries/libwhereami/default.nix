{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  pname = "libwhereami";
  version = "0.3.0";

  src = fetchFromGitHub {
    sha256 = "0yq6m4kh06idp3l8cp7kswn5k8vcaip1zqhypbhszybqa0afb5az";
    rev = version;
    repo = "libwhereami";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=catch-value" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Library to report hypervisor information from inside a VM";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = with platforms; [ "i686-linux" "x86_64-linux" ]; # fails on aarch64
  };

}
