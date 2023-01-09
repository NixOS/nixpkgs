{ stdenv
, lib
, abc-verifier
, bash
, bison
, fetchFromGitHub
, flex
, libffi
, makeWrapper
, pkg-config
, python3
, readline
, symlinkJoin
, tcl
, verilog
, zlib
, yosys
, yosys-bluespec
, yosys-ghdl
, yosys-symbiflow
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
  withPlugins = plugins:
    let
      paths = lib.closePropagation plugins;
      module_flags = with builtins; concatStringsSep " "
        (map (n: "--add-flags -m --add-flags ${n.plugin}") plugins);
    in lib.appendToName "with-plugins" ( symlinkJoin {
      inherit (yosys) name;
      paths = paths ++ [ yosys ] ;
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/yosys \
          --set NIX_YOSYS_PLUGIN_DIRS $out/share/yosys/plugins \
          ${module_flags}
      '';
    });

  allPlugins = {
    bluespec = yosys-bluespec;
    ghdl     = yosys-ghdl;
  } // (yosys-symbiflow);


in stdenv.mkDerivation rec {
  pname   = "yosys";
  version = "0.25";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo  = "yosys";
    rev   = "${pname}-${version}";
    hash  = "sha256-hOuuKvT6ZM7G0HTGtVeEHHfJWqwUinD+DxT3r0CQZH0=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config bison flex ];
  buildInputs = [
    tcl
    readline
    libffi
    zlib
    (python3.withPackages (pp: with pp; [
      click
    ]))
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}"];

  patches = [
    ./plugin-search-dirs.patch
    ./fix-clang-build.patch # see https://github.com/YosysHQ/yosys/issues/2011
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

    if ! grep -q "ABCREV = ${shortAbcRev}" Makefile; then
      echo "ERROR: yosys isn't compatible with the provided abc (${shortAbcRev}), failing."
      exit 1
    fi

    if ! grep -q "YOSYS_VER := $version" Makefile; then
      echo "ERROR: yosys version in Makefile isn't equivalent to version of the nix package (allegedly ${version}), failing."
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

  passthru = {
    inherit withPlugins allPlugins;
  };

  meta = with lib; {
    description = "Open RTL synthesis framework and tools";
    homepage    = "https://yosyshq.net/yosys/";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ shell thoughtpolice emily ];
  };
}
