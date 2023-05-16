{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.2.6";
=======
  version = "1.2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "libnftnl";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.xz";
<<<<<<< HEAD
    hash = "sha256-zurqLNkhR9oZ8To1p/GkvCdn/4l+g45LR5z1S1nHd/Q=";
=======
    hash = "sha256-lm3gqBIMilPbhZiJdJNov7LLoMTwtMGjDSZOzMRfEiY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  meta = with lib; {
    description = "A userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = "https://netfilter.org/projects/libnftnl/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ajs124 ];
  };
}
