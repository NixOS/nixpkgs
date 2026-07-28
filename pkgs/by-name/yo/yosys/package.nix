{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  bison,
  cmake,
  flex,
  ninja,
  pkg-config,
  python3,

  # buildInputs
  gtest,
  libffi,
  readline,
  tcl,
  zlib,

  # tests
  gtkwave,
  iverilog,

  # passthru
  symlinkJoin,
  yosys,
  makeWrapper,
  yosys-bluespec,
  yosys-ghdl,
  yosys-symbiflow,
  nix-update-script,
  enablePython ? true, # enable python binding
}:

let
  withPlugins =
    plugins:
    let
      paths = lib.closePropagation plugins;
      libExt = stdenv.hostPlatform.extensions.sharedLibrary;
      pluginPath = "$out/share/yosys/plugins";
      module_flags =
        with builtins;
        concatStringsSep " " (
          map (n: "--add-flags -m --add-flags ${pluginPath}/${n.plugin}${libExt}") plugins
        );
    in
    lib.appendToName "with-plugins" (symlinkJoin {
      inherit (yosys) name;
      paths = paths ++ [ yosys ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/yosys \
          --set YOSYS_PATH $out/share/yosys \
          --set YOSYS_PLUGIN_PATH ${pluginPath} \
          ${module_flags}
      '';
      meta.mainProgram = "yosys";
    });

  allPlugins = {
    bluespec = yosys-bluespec;
    ghdl = yosys-ghdl;
  }
  // yosys-symbiflow;

  pythonEnv = python3.withPackages (
    pp:
    with pp;
    [ click ]
    ++ lib.optionals enablePython [
      pybind11
      cxxheaderparser
    ]
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "yosys";
  version = "0.67";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sJaekoBnLEn7j56duQOFMkT4fELHNgkYCbcY6E8hgyA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs tests
    substituteInPlace tests/aiger/generate_mk.py \
      --replace-fail 'SHELL := /usr/bin/env bash' 'SHELL := ${stdenv.shell}'
    # these plugin tests only work against the installed output, so skip them.
    rm tests/various/plugin.sh tests/various/ezcmdline_plugin.sh
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    ninja
    pkg-config
    pythonEnv
  ];

  buildInputs = [
    gtest
    libffi
    readline
    tcl
    zlib
  ]
  ++ lib.optionals enablePython [
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "YOSYS_SKIP_ABC_SUBMODULE_CHECK" true)
    (lib.cmakeFeature "YOSYS_CHECKOUT_INFO" "v${finalAttrs.version}")
    # slang is not packaged yet.
    (lib.cmakeBool "YOSYS_WITHOUT_SLANG" true)
    (lib.cmakeBool "YOSYS_WITH_PYTHON" enablePython)
  ]
  ++ lib.optionals enablePython [
    (lib.cmakeBool "YOSYS_INSTALL_PYTHON" true)
    (lib.cmakeFeature "YOSYS_INSTALL_PYTHON_SITEDIR" "${placeholder "out"}/${python3.sitePackages}")
  ];

  checkTarget = "test";
  doCheck = true;
  nativeCheckInputs = [
    gtkwave
    iverilog
  ];

  setupHook = ./setup-hook.sh;

  passthru = {
    inherit withPlugins allPlugins;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open RTL synthesis framework and tools";
    homepage = "https://yosyshq.net/yosys/";
    changelog = "https://github.com/YosysHQ/yosys/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    mainProgram = "yosys";
    maintainers = with lib.maintainers; [
      shell
      thoughtpolice
      Luflosi
    ];
  };
})
