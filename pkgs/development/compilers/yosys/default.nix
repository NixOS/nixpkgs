{ stdenv
, abc-verifier
, bash
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
  pname   = "yosys";
  version = "2020.07.07";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "yosys";
    rev    = "000fd08198487cd1d36e65e4470f4b0269c23a2b";
    sha256 = "01s252vwh4g1f4y99nfrkpf6hgvh9k63nz8hvpmjza5z8x6zf4i1";
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
    substituteInPlace ./misc/yosys-config.in \
      --replace '/bin/bash' '${bash}/bin/bash'
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

    if ! grep -q "ABCREV = ${shortAbcRev}" Makefile; then
      echo "yosys isn't compatible with the provided abc (${shortAbcRev}), failing."
      exit 1
    fi
  '';

  doCheck = true;
  checkInputs = [ verilog ];

  # Internally, yosys knows to use the specified hardcoded ABCEXTERNAL binary.
  # But other tools (like mcy or symbiyosys) can't know how yosys was built, so
  # they just assume that 'yosys-abc' is available -- but it's not installed
  # when using ABCEXTERNAL
  #
  # add a symlink to fake things so that both variants work the same way.
  postInstall = ''
    ln -sfv ${abc-verifier}/bin/abc $out/bin/yosys-abc
  '';

  meta = with stdenv.lib; {
    description = "Open RTL synthesis framework and tools";
    homepage    = "http://www.clifford.at/yosys/";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ shell thoughtpolice emily ];
  };
}
