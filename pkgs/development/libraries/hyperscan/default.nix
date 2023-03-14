{ lib, stdenv, fetchFromGitHub, cmake, ragel, python3
, util-linux, fetchpatch
, boost
, withStatic ? false # build only shared libs by default, build static+shared if true
}:

# NOTICE: pkg-config, pcap and pcre intentionally omitted from build inputs
#         pcap used only in examples, pkg-config used only to check for pcre
#         which is fixed 8.41 version requirement (nixpkgs have 8.42+, and
#         I not see any reason (for now) to backport 8.41.

stdenv.mkDerivation rec {
  pname = "hyperscan";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = pname;
    sha256 = "sha256-AJAjaXVnGqIlMk+gb6lpTLUdZr8nxn2XSW4fj6j/cmk=";
    rev = "v${version}";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ boost ];
  nativeBuildInputs = [
    cmake ragel python3
    # Consider simply using busybox for these
    # Need at least: rev, sed, cut, nm
    util-linux
  ];

  cmakeFlags = [
    "-DFAT_RUNTIME=ON"
    "-DBUILD_AVX512=ON"
  ]
  ++ lib.optional (withStatic) "-DBUILD_STATIC_AND_SHARED=ON"
  ++ lib.optional (!withStatic) "-DBUILD_SHARED_LIBS=ON";

  patches = [
    (fetchpatch {
      # part of https://github.com/intel/hyperscan/pull/336
      url = "https://github.com/intel/hyperscan/commit/e2c4010b1fc1272cab816ba543940b3586e68a0c.patch";
      sha256 = "sha256-doVNwROL6MTcgOW8jBwGTnxe0zvxjawiob/g6AvXLak=";
    })
  ];

  postPatch = ''
    sed -i '/examples/d' CMakeLists.txt
    substituteInPlace libhs.pc.in \
      --replace "libdir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@" "libdir=@CMAKE_INSTALL_LIBDIR@" \
      --replace "includedir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_INCLUDEDIR@" "includedir=@CMAKE_INSTALL_INCLUDEDIR@"
  '';

  meta = with lib; {
    description = "High-performance multiple regex matching library";
    longDescription = ''
      Hyperscan is a high-performance multiple regex matching library.
      It follows the regular expression syntax of the commonly-used
      libpcre library, but is a standalone library with its own C API.

      Hyperscan uses hybrid automata techniques to allow simultaneous
      matching of large numbers (up to tens of thousands) of regular
      expressions and for the matching of regular expressions across
      streams of data.

      Hyperscan is typically used in a DPI library stack.
    '';

    homepage = "https://www.hyperscan.io/";
    maintainers = with maintainers; [ avnik ];
    platforms = [ "x86_64-linux" ]; # can't find nm on darwin ; might build on aarch64 but untested
    license = licenses.bsd3;
  };
}
