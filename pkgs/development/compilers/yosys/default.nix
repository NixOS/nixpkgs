{ stdenv
, bison
, fetchFromGitHub
, flex
, libffi
, pkgconfig
, protobuf
, python3
, readline
, tcl
, verilog
, zlib
}:

with builtins;

let
  # NOTE: the version of abc used here is synchronized with
  # the one in the yosys Makefile of the version above;
  # keep them the same for quality purposes.
  abc = fetchFromGitHub {
    owner  = "berkeley-abc";
    repo   = "abc";
    rev    = "623b5e82513d076a19f864c01930ad1838498894";
    sha256 = "1mrfqwsivflqdzc3531r6mzp33dfyl6dnqjdwfcq137arqh36m67";
  };
in stdenv.mkDerivation rec {
  pname = "yosys";
  version = "2019.10.18";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "yosys";
    rev    = "3c41599ee1f62e4d77ba630fa1a245ef3fe236fa";
    sha256 = "0jg2g8v08ax1q6qlvn8c1h147m03adzrgf21043xwbh4c7s5k137";
    name   = "yosys";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ tcl readline libffi python3 bison flex protobuf zlib ];

  makeFlags = [ "ENABLE_PROTOBUF=1" "PREFIX=${placeholder "out"}"];

  patchPhase = ''
    substituteInPlace ./Makefile \
      --replace 'CXX = clang' "" \
      --replace 'LD = clang++' 'LD = $(CXX)' \
      --replace 'CXX = gcc' "" \
      --replace 'LD = gcc' 'LD = $(CXX)' \
      --replace 'ABCMKARGS = CC="$(CXX)" CXX="$(CXX)"' 'ABCMKARGS =' \
      --replace 'echo UNKNOWN' 'echo ${substring 0 10 src.rev}'
    patchShebangs tests
  '';

  preBuild = ''
    cp -R ${abc} abc
    chmod -R u+w .
    substituteInPlace abc/Makefile \
      --replace 'CC   := gcc' "" \
      --replace 'CXX  := g++' ""
    make config-${if stdenv.cc.isClang or false then "clang" else "gcc"}
    echo 'ABCREV := default' >> Makefile.conf

    # we have to do this ourselves for some reason...
    (cd misc && ${protobuf}/bin/protoc --cpp_out ../backends/protobuf/ ./yosys.proto)
  '';

  doCheck = true;
  checkInputs = [ verilog ];
  # checkPhase defaults to VERBOSE=y, which gets passed down to abc,
  # which then does $(VERBOSE)gcc, which then complains about not
  # being able to find ygcc. Life is pain.
  checkFlags = [ " " ];

  meta = {
    description = "Framework for RTL synthesis tools";
    longDescription = ''
      Yosys is a framework for RTL synthesis tools. It currently has
      extensive Verilog-2005 support and provides a basic set of
      synthesis algorithms for various application domains.
      Yosys can be adapted to perform any synthesis job by combining
      the existing passes (algorithms) using synthesis scripts and
      adding additional passes as needed by extending the yosys C++
      code base.
    '';
    homepage    = http://www.clifford.at/yosys/;
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
