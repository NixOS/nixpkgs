{ lib, stdenv, fetchFromGitHub, cmake, ragel, python27
, coreutils, gnused, utillinux
, boost
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
    repo = "hyperscan";
    sha256 = "11adkz5ln2d2jywwlmixfnwqp5wxskq1104hmmcpws590lhkjv6j";
    rev = "v${version}";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ boost ];
  nativeBuildInputs = [
    cmake ragel python27
    # Consider simply using busybox for these
    # Need at least: rev, sed, cut
    coreutils gnused utillinux
  ];

  cmakeFlags = [
    "-DFAT_RUNTIME=ON"
    "-DBUILD_AVX512=ON"
    "-DBUILD_STATIC_AND_SHARED=ON"
  ];

  prePatch = ''
    sed -i '/examples/d' CMakeLists.txt
  '';

  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/*.a $dev/lib/
    ln -sf $out/lib/libhs.so $dev/lib/
    ln -sf $out/lib/libhs_runtime.so $dev/lib/
  '';

  postFixup = ''
    sed -i "s,$out/include,$dev/include," $dev/lib/pkgconfig/libhs.pc
    sed -i "s,$out/lib,$dev/lib," $dev/lib/pkgconfig/libhs.pc
  '';

  meta = {
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

    homepage = https://www.hyperscan.io/;
    maintainers = with lib.maintainers; [ avnik ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    license = lib.licenses.bsd3;
  };
}
