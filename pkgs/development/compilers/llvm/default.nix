{ stdenv, fetchurl, perl, groff, cmake, python, libffi, libcxx }:

let version = "3.2"; in

stdenv.mkDerivation {
  name = "llvm-${version}";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/llvm-${version}.src.tar.gz";
    sha256 = "0hv30v5l4fkgyijs56sr1pbrlzgd674pg143x7az2h37sb290l0j";
  };

  preConfigure = ''
    patchShebangs .
    export REQUIRES_RTTI=1
  '';

  # ToDo: polly, libc++; --enable-cxx11?

  configureFlags = [
    "--enable-shared" # saves half the size, and even more for e.g. mesa
    "--disable-assertions" "--enable-optimized"
    "--disable-timestamps" # embedding timestamps seems a danger to purity
    "--enable-libffi"
    #"--enable-experimental-targets=r600"
    #"--enable-libcpp"
  ] ;

  patches = [ ./set_soname.patch ]; # http://llvm.org/bugs/show_bug.cgi?id=12334
  patchFlags = "-p0";

  buildInputs = [ perl groff python ]
    #++ [ libcxx ]
    ;
  propagatedBuildInputs = [ libffi ];

  enableParallelBuilding = true;
  #ToDo: doCheck?

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy raskin];
    platforms = with stdenv.lib.platforms; all;
  };
}
