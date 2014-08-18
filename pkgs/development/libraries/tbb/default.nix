{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "tbb-4.0-u5";

  src = fetchurl {
    url = "http://threadingbuildingblocks.org/uploads/77/187/4.0%20update%205/tbb40_20120613oss_src.tgz";
    sha256 = "aaa98146049e55f6ac969298340eeb49df61395403fcc1480824a4ecd0d46192";
  };

  checkTarget = "test";
  doCheck = false;

  installPhase = ''
    mkdir -p $out/{lib,share/doc}
    cp "build/"*release*"/"*so* $out/lib/
    mv include $out/
    rm $out/include/index.html
    mv doc/html $out/share/doc/tbb
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://threadingbuildingblocks.org/";
    description = "Intel Thread Building Blocks C++ Library";
    license = "LGPLv3+";

    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
