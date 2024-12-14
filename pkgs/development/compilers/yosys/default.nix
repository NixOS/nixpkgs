{
  stdenv,
  lib,
  bison,
  boost,
  fetchFromGitHub,
  flex,
  libffi,
  makeWrapper,
  pkg-config,
  python3,
  readline,
  symlinkJoin,
  tcl,
  iverilog,
  zlib,
  yosys,
  yosys-bluespec,
  yosys-ghdl,
  yosys-symbiflow,
  enablePython ? true, # enable python binding
}:

# NOTE: as of late 2020, yosys has switched to an automation robot that
# automatically tags their repository Makefile with a new build number every
# day when changes are committed. please MAKE SURE that the version number in
# the 'version' field exactly matches the YOSYS_VER field in the Yosys
# makefile!
#
# if a change in yosys isn't yet available under a build number like this (i.e.
# it was very recently merged, within an hour), wait a few hours for the
# automation robot to tag the new version, like so:
#
#     https://github.com/YosysHQ/yosys/commit/71ca9a825309635511b64b3ec40e5e5e9b6ad49b
#
# note that while most nix packages for "unstable versions" use a date-based
# version scheme, synchronizing the nix package version here with the unstable
# yosys version number helps users report better bugs upstream, and is
# ultimately less confusing than using dates.

let

  # Provides a wrapper for creating a yosys with the specifed plugins preloaded
  #
  # Example:
  #
  #     my_yosys = yosys.withPlugins (with yosys.allPlugins; [
  #        fasm
  #        bluespec
  #     ]);
  withPlugins =
    plugins:
    let
      paths = lib.closePropagation plugins;
      module_flags =
        with builtins;
        concatStringsSep " " (map (n: "--add-flags -m --add-flags ${n.plugin}") plugins);
    in
    lib.appendToName "with-plugins" (symlinkJoin {
      inherit (yosys) name;
      paths = paths ++ [ yosys ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/yosys \
          --set NIX_YOSYS_PLUGIN_DIRS $out/share/yosys/plugins \
          ${module_flags}
      '';
    });

  allPlugins = {
    bluespec = yosys-bluespec;
    ghdl = yosys-ghdl;
  } // (yosys-symbiflow);

  boost_python = boost.override {
    enablePython = true;
    python = python3;
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "yosys";
  version = "0.47";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-9u9aAPTZyt9vzZwryor3GRCGzs/mu2/XtM0XzV7uHfk=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      # set up git hashes as if we used the tarball

      pushd $out
      git rev-parse HEAD > .gitcommit
      cd $out/abc
      git rev-parse HEAD > .gitcommit
      popd

      # remove .git now that we are through with it
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [
    pkg-config
    bison
    flex
  ];
  propagatedBuildInputs = [
    tcl
    readline
    libffi
    zlib
    (python3.withPackages (
      pp: with pp; [
        click
      ]
    ))
  ] ++ lib.optional enablePython boost_python;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  patches = [
    ./plugin-search-dirs.patch
    ./fix-clang-build.patch # see https://github.com/YosysHQ/yosys/issues/2011
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace-fail 'echo UNKNOWN' 'echo ${builtins.substring 0 10 finalAttrs.src.rev}'

    patchShebangs tests ./misc/yosys-config.in
  '';

  preBuild =
    ''
      chmod -R u+w .
      make config-${if stdenv.cc.isClang or false then "clang" else "gcc"}

      if ! grep -q "YOSYS_VER := $version" Makefile; then
        echo "ERROR: yosys version in Makefile isn't equivalent to version of the nix package (allegedly ${finalAttrs.version}), failing."
        exit 1
      fi
    ''
    + lib.optionalString enablePython ''
      echo "ENABLE_PYOSYS := 1" >> Makefile.conf
      echo "PYTHON_DESTDIR := $out/${python3.sitePackages}" >> Makefile.conf
      echo "BOOST_PYTHON_LIB := -lboost_python${lib.versions.major python3.version}${lib.versions.minor python3.version}" >> Makefile.conf
    '';

  preCheck = ''
    # autotest.sh automatically compiles a utility during startup if it's out of date.
    # having N check jobs race to do that creates spurious codesigning failures on macOS.
    # run it once without asking it to do anything so that compilation is done before the jobs start.
    tests/tools/autotest.sh
  '';

  checkTarget = "test";
  doCheck = true;
  nativeCheckInputs = [ iverilog ];

  setupHook = ./setup-hook.sh;

  passthru = {
    inherit withPlugins allPlugins;
  };

  meta = with lib; {
    description = "Open RTL synthesis framework and tools";
    homepage = "https://yosyshq.net/yosys/";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [
      shell
      thoughtpolice
      Luflosi
    ];
  };
})
