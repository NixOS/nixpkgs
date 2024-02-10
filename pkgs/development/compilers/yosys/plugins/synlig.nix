{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, pkg-config
, antlr4
, capnproto
, readline
, surelog
, uhdm
, yosys
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yosys-synlig";
  plugin = "synlig";

  # The module has automatic regular releases, with date + short git hash
  GIT_VERSION = "2023-11-28-b8ed72d";

  # Derive our package version from GIT_VERSION, remove hash, just keep date.
  version = builtins.concatStringsSep "-" (
    lib.take 3 (builtins.splitVersion finalAttrs.GIT_VERSION));

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo  = "synlig";
    rev   = "${finalAttrs.GIT_VERSION}";
    hash  = "sha256-jdA3PBodecqriGWU/BzWtQ5gyu62pZHv+1NvFrwsTTk=";
    fetchSubmodules = false;  # we use all dependencies from nix
  };

  patches = [
    (fetchpatch {
      # Fixes https://github.com/chipsalliance/synlig/issues/2299
      name = "make-compile-for-yosys-0.37.patch";
      url = "https://github.com/chipsalliance/synlig/commit/3dd46d4769c20b6dd1163310f8e56560b351a211.patch";
      hash = "sha256-OP/2HA/Ukt6o5aKgoBk19P6T/33btU/x6VnoIVXct1g=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    antlr4.runtime.cpp
    capnproto
    readline
    surelog
    uhdm
    yosys
  ];

  buildPhase = ''
    runHook preBuild

    # Remove assumptions that submodules are available.
    rm -f third_party/Build.*.mk

    # Create a stub makefile include that delegates the parameter-gathering
    # to yosys-config
    cat > third_party/Build.yosys.mk << "EOF"
    t  := yosys
    ts := ''$(call GetTargetStructName,''${t})

    ''${ts}.src_dir   := ''$(shell yosys-config --datdir/include)
    ''${ts}.mod_dir   := ''${TOP_DIR}third_party/yosys_mod/
    EOF

    make -j $NIX_BUILD_CORES build@systemverilog-plugin \
            LDFLAGS="''$(yosys-config --ldflags --ldlibs)"
    runHook postBuild
  '';

  # Check that the plugin can be loaded successfully and parse simple file.
  doCheck = true;
  checkPhase = ''
     runHook preCheck
     echo "module litmustest(); endmodule;" > litmustest.sv
     yosys -p "plugin -i build/release/systemverilog-plugin/systemverilog.so;\
               read_systemverilog litmustest.sv"
     runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/yosys/plugins
    cp ./build/release/systemverilog-plugin/systemverilog.so \
           $out/share/yosys/plugins/systemverilog.so
    runHook postInstall
  '';

  meta = with lib; {
    description = "SystemVerilog support plugin for Yosys";
    homepage    = "https://github.com/chipsalliance/synlig";
    license     = licenses.asl20;
    maintainers = with maintainers; [ hzeller ];
    platforms   = platforms.all;
  };
})
