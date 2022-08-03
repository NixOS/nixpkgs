{ lib, stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  pname = "libwhereami";
  version = "0.5.0";

  src = fetchFromGitHub {
    sha256 = "05fc28dri2h858kxbvldk5b6wd5is3fjcdsiqj3nxf95i66bb3xp";
    rev = version;
    repo = "libwhereami";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Library to report hypervisor information from inside a VM";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ]; # fails on aarch64
  };

}
