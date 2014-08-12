{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "tbb-4.2-u5";

  src = fetchurl {
    url = "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb42_20140601oss_src.tgz";
    sha256 = "1zjh81hvfxvk1v1li27w1nm3bp6kqv913lxfb2pqa134dibw2pp7";
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
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = stdenv.lib.licenses.lgpl3Plus;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ simons thoughtpolice ];
  };
}
