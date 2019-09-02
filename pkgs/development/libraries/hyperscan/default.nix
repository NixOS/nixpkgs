{ stdenv, fetchFromGitHub, cmake, ragel, python3
, coreutils, gnused, utillinux
, boost
, withStatic ? false # build only shared libs by default, build static+shared if true
}:

# NOTICE: pkgconfig, pcap and pcre intentionally omitted from build inputs
#         pcap used only in examples, pkgconfig used only to check for pcre
#         which is fixed 8.41 version requirement (nixpkgs have 8.42+, and
#         I not see any reason (for now) to backport 8.41.

stdenv.mkDerivation rec {
  pname = "hyperscan";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = pname;
    sha256 = "11adkz5ln2d2jywwlmixfnwqp5wxskq1104hmmcpws590lhkjv6j";
    rev = "v${version}";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ boost ];
  nativeBuildInputs = [
    cmake ragel python3
    # Consider simply using busybox for these
    # Need at least: rev, sed, cut, nm
    coreutils gnused utillinux
  ];

  cmakeFlags = [
    "-DFAT_RUNTIME=ON"
    "-DBUILD_AVX512=ON"
  ]
  ++ stdenv.lib.optional (withStatic) "-DBUILD_STATIC_AND_SHARED=ON"
  ++ stdenv.lib.optional (!withStatic) "-DBUILD_SHARED_LIBS=ON";

  postPatch = ''
    sed -i '/examples/d' CMakeLists.txt
    substituteInPlace libhs.pc.in \
      --replace "libdir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@" "libdir=@CMAKE_INSTALL_LIBDIR@" \
      --replace "includedir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_INCLUDEDIR@" "includedir=@CMAKE_INSTALL_INCLUDEDIR@"
  '';

  meta = with stdenv.lib; {
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
