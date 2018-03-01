{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  name = "libwhereami-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    sha256 = "0mpy2rkxcm2nz1qvldih01czxlsksqfkzgh58pnrw8yva31wv9q6";
    rev = version;
    repo = "libwhereami";
    owner = "puppetlabs";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Library to report hypervisor information from inside a VM";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
