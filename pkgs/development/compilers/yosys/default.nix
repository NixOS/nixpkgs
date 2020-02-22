{ stdenv
, abc-verifier
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

stdenv.mkDerivation rec {
  pname = "yosys";
  version = "2020.02.07";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "yosys";
    rev    = "2e8d6ec0b06b4e51e222c15c8049130bc264ae57";
    sha256 = "0asnqhxs5r5r2xmvsk9pbgyqgk53j1snh7c9qizcppn4csapda81";
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
      --replace 'echo UNKNOWN' 'echo ${builtins.substring 0 10 src.rev}'
    patchShebangs tests
  '';

  preBuild = let
    shortAbcRev = builtins.substring 0 7 abc-verifier.rev;
  in ''
    chmod -R u+w .
    make config-${if stdenv.cc.isClang or false then "clang" else "gcc"}
    echo 'ABCEXTERNAL = ${abc-verifier}/bin/abc' >> Makefile.conf

    # we have to do this ourselves for some reason...
    (cd misc && ${protobuf}/bin/protoc --cpp_out ../backends/protobuf/ ./yosys.proto)

    if ! grep -q "ABCREV = ${shortAbcRev}" Makefile;then
      echo "yosys isn't compatible with the provided abc (${shortAbcRev}), failing."
      exit 1
    fi
  '';

  doCheck = true;
  checkInputs = [ verilog ];

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
