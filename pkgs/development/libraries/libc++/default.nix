{ stdenv, fetchsvn, cmake }:

let rev = "165151"; in

stdenv.mkDerivation {
  name = "libc++-pre${rev}";

  src = fetchsvn {
    url = "http://llvm.org/svn/llvm-project/libcxx/trunk";
    inherit rev;
    sha256 = "00l8xx5nc3cjlmln7c1sy1i4v844has9kbfxrsziwkalzbgwaslz";
  };

  buildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://libcxx.llvm.org/;
    description = "A new implementation of the C++ standard library, targeting C++11";
    license = "BSD";
    maintainers = stdenv.lib.maintainers.shlevy;
    platforms = stdenv.lib.platforms.all;
  };
}

