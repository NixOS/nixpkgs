{ stdenv, fetchFromGitHub
, pkgconfig, bison, flex
, tcl, readline, libffi, python3
, protobuf
}:

with builtins;

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2019.01.08";

  srcs = [
    (fetchFromGitHub {
      owner  = "yosyshq";
      repo   = "yosys";
      rev    = "2a2e0a4722ded7628b71f436b94a06aebd57bb62";
      sha256 = "19wzh7yssk90s58l2f89m0q5bjjrjpkhvikf5zc0563wccvl712c";
      name   = "yosys";
    })

    # NOTE: the version of abc used here is synchronized with
    # the one in the yosys Makefile of the version above;
    # keep them the same for quality purposes.
    (fetchFromGitHub {
      owner  = "berkeley-abc";
      repo   = "abc";
      rev    = "2ddc57d8760d94e86699be39a628178cff8154f8";
      sha256 = "0da7nnnnl9cq2r7s301xgdc8nlr6hqmqpvd9zn4b58m125sp0scl";
      name   = "yosys-abc";
    })
  ];
  sourceRoot = "yosys";

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ tcl readline libffi python3 bison flex protobuf ];

  makeFlags = [ "ENABLE_PROTOBUF=1" ];

  patchPhase = ''
    substituteInPlace ../yosys-abc/Makefile \
      --replace 'CC   := gcc' ""
    substituteInPlace ./Makefile \
      --replace 'CXX = clang' "" \
      --replace 'ABCMKARGS = CC="$(CXX)"' 'ABCMKARGS =' \
      --replace 'echo UNKNOWN' 'echo ${substring 0 10 (elemAt srcs 0).rev}'
  '';

  preBuild = ''
    chmod -R u+w ../yosys-abc
    ln -s ../yosys-abc abc
    make config-${if stdenv.cc.isClang or false then "clang" else "gcc"}
    echo 'ABCREV := default' >> Makefile.conf
    makeFlags="PREFIX=$out $makeFlags"

    # we have to do this ourselves for some reason...
    (cd misc && ${protobuf}/bin/protoc --cpp_out ../backends/protobuf/ ./yosys.proto)
  '';

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
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
