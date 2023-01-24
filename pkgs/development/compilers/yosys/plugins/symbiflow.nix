{ fetchFromGitHub
, gtest
, lib
, python3
, readline
, stdenv
, yosys
, zlib
, yosys-symbiflow
, uhdm
, surelog
, flatbuffers
}: let

  src = fetchFromGitHub {
    owner  = "chipsalliance";
    repo   = "yosys-f4pga-plugins";
    rev    = "e23ff6db487da9ceea576c53ac33853566c3a84e";
    hash   = "sha256-HJ4br6lQwRrcnkLgV3aecr3T3zcPzA11MfxhRjwIb0I=";
  };

  version = "2022.11.07";

  # Supported symbiflow plugins.
  #
  # The following are disabled:
  #
  # "ql-qlf" builds but fails to load the plugin, so is not currently supported.
  plugins = [
    "design_introspection"
    "fasm"
    "integrateinv"
    "params"
    "ql-iob"
    # "ql-qlf"
    "sdc"
    "xdc"
    "systemverilog"
  ];

  static_gtest = gtest.dev.overrideAttrs (old: {
    dontDisableStatic = true;
    disableHardening = [ "pie" ];
    cmakeFlags = old.cmakeFlags ++ ["-DBUILD_SHARED_LIBS=OFF"];
  });

in lib.genAttrs plugins (plugin: stdenv.mkDerivation (rec {
  pname = "yosys-symbiflow-${plugin}-plugin";
  inherit src version plugin;
  enableParallelBuilding = true;

  nativeBuildInputs = [ python3 ];
  buildInputs = [ yosys readline zlib uhdm surelog ];

  # xdc has an incorrect path to a test which has yet to be patched
  doCheck = plugin != "xdc";
  nativeCheckInputs = [ static_gtest ];

  # ql-qlf tries to fetch a yosys script from github
  # Run the script in preBuild instead.
  patches = lib.optional ( plugin == "ql-qlf" ) ./symbiflow-pmgen.patch;

  preBuild = ''
    export LDFLAGS="-L${flatbuffers}/lib"
    mkdir -p ql-qlf-plugin/pmgen
  ''
  + lib.optionalString ( plugin == "ql-qlf" ) ''
    python3 ${yosys.src}/passes/pmgen/pmgen.py -o ql-qlf-plugin/pmgen/ql-dsp-pm.h -p ql_dsp ql-qlf-plugin/ql_dsp.pmg
  '';

  # Providing a symlink avoids the need for patching the test makefile
  postUnpack = ''
    mkdir -p source/third_party/googletest/build/
    ln -s ${static_gtest}/lib source/third_party/googletest/build/lib
  '';

  makeFlags = [
    "PLUGIN_LIST=${plugin}"
  ];

  buildFlags = [
    "PLUGINS_DIR=\${out}/share/yosys/plugins/"
    "DATA_DIR=\${out}/share/yosys/"
  ];

  checkFlags = [
    "PLUGINS_DIR=\${NIX_BUILD_TOP}/source/${plugin}-plugin"
    "DATA_DIR=\${NIX_BUILD_TOP}/source/${plugin}-plugin"
    ( "NIX_YOSYS_PLUGIN_DIRS=\${NIX_BUILD_TOP}/source/${plugin}-plugin"
      # sdc and xdc plugins use design introspection for their tests
      + (lib.optionalString ( plugin == "sdc" || plugin == "xdc" )
        ":${yosys-symbiflow.design_introspection}/share/yosys/plugins/")
    )
  ];

  installFlags = buildFlags;

  meta = with lib; {
    description = "Symbiflow ${plugin} plugin for Yosys";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ ollieB thoughtpolice ];
  };
}))
