{ stdenv
, lib
, abc-verifier
, bash
, bison
, fetchFromGitHub
, flex
, libffi
, pkg-config
, protobuf
, python3
, readline
, tcl
, verilog
, zlib
}:

stdenv.mkDerivation rec {
  pname   = "yosys";
  version = "0.10";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "yosys";
    rev    = "yosys-${version}";
    sha256 = "1x51avmi516id1hv37my3pvzpcligrp9hjcw2f48fgffag4lqgwb";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config bison flex ];
  buildInputs = [ tcl readline libffi python3 protobuf zlib ];

  makeFlags = [ "ENABLE_PROTOBUF=1" "PREFIX=${placeholder "out"}"];

  patches = [
    ./plugin-search-dirs.patch
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace 'echo UNKNOWN' 'echo ${builtins.substring 0 10 src.rev}'

    chmod +x ./misc/yosys-config.in
    patchShebangs tests ./misc/yosys-config.in
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
      echo "ERROR: yosys isn't compatible with the provided abc (${shortAbcRev}), failing."
      exit 1
    fi

    if ! grep -q "YOSYS_VER := $version" Makefile; then
      echo "ERROR: yosys version in Makefile isn't equivalent to version of the nix package (${version}), failing."
      exit 1
    fi
  '';

  checkTarget = "test";
  doCheck = true;
  checkInputs = [ verilog ];

  # Internally, yosys knows to use the specified hardcoded ABCEXTERNAL binary.
  # But other tools (like mcy or symbiyosys) can't know how yosys was built, so
  # they just assume that 'yosys-abc' is available -- but it's not installed
  # when using ABCEXTERNAL
  #
  # add a symlink to fake things so that both variants work the same way. this
  # is also needed at build time for the test suite.
  postBuild   = "ln -sfv ${abc-verifier}/bin/abc ./yosys-abc";
  postInstall = "ln -sfv ${abc-verifier}/bin/abc $out/bin/yosys-abc";

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Open RTL synthesis framework and tools";
    homepage    = "http://www.clifford.at/yosys/";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ shell thoughtpolice emily ];
    #In file included from kernel/driver.cc:20:
    #./kernel/yosys.h:42:10: fatal error: 'map' file not found
    ##include <map>

    #https://github.com/YosysHQ/yosys/issues/681
    #https://github.com/YosysHQ/yosys/issues/2011
    broken = stdenv.isDarwin;
  };
}
