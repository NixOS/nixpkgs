{ stdenv, fetchFromGitHub, compiler ? if stdenv.cc.isClang then "clang" else null, stdver ? null }:

with stdenv.lib; stdenv.mkDerivation rec {
  name = "tbb-${version}";
  version = "2018_U1";

  src = fetchFromGitHub {
    owner = "01org";
    repo = "tbb";
    rev = version;
    sha256 = "1lygz07va6hsv2vlx9zwz5d2n81rxsdhmh0pqxgj8n1bvb1rp0qw";
  };

  makeFlags = concatStringsSep " " (
    optional (compiler != null) "compiler=${compiler}" ++
    optional (stdver != null) "stdver=${stdver}"
  );

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl ./glibc-struct-mallinfo.patch;

  installPhase = ''
    mkdir -p $out/{lib,share/doc}
    cp "build/"*release*"/"*${stdenv.hostPlatform.extensions.sharedLibrary}* $out/lib/
    mv include $out/
    rm $out/include/index.html
    mv doc/html $out/share/doc/tbb
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ peti thoughtpolice dizfer ];
  };
}
