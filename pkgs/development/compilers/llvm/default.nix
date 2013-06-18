{ stdenv, fetchurl, perl, groff, cmake, python, libffi }:

let version = "3.2"; in

stdenv.mkDerivation {
  name = "llvm-${version}";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/llvm-${version}.src.tar.gz";
    sha256 = "0hv30v5l4fkgyijs56sr1pbrlzgd674pg143x7az2h37sb290l0j";
  };

  patches = [ ./set_soname.patch ]; # http://llvm.org/bugs/show_bug.cgi?id=12334
  patchFlags = "-p0";

  preConfigure = "patchShebangs .";

  propagatedBuildInputs = [ libffi ];
  buildInputs = [ perl groff cmake python ]; # ToDo: polly, libc++; enable cxx11?

  # created binaries need to be run before installation... I coudn't find a better way
  preBuild = ''export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:"`pwd`/lib'';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DBUILD_SHARED_LIBS=ON" ];

  enableParallelBuilding = true;
  #doCheck = true; # tests are broken, don't know why

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy raskin];
    platforms = with stdenv.lib.platforms; all;
  };
}
