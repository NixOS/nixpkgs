{ stdenv
, fetchFromGitHub
, fixDarwinDylibNames
, cmake
}:

with stdenv.lib; stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2021.1.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    sha256 = "sha256-uI6q+1okoJ7x88ay7XTNMhT+0uYDfu+1zf0RcGCyilc=";
  };

  nativeBuildInputs = [ cmake ] ++ optional stdenv.isDarwin fixDarwinDylibNames;

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  # tbb detects this compiler as Clang instead of AppleClang
  prePatch = stdenv.lib.optional stdenv.hostPlatform.isDarwin ''
    mv cmake/compilers/AppleClang.cmake cmake/compilers/Clang.cmake
  '';

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl ./glibc-struct-mallinfo.patch;

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
    maintainers = with maintainers; [ thoughtpolice dizfer ];
  };
}
