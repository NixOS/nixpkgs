{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  boost,
  cmake,
}:

let
  rev = "e821bcbecdc997d71766836a200e16b27535a835";
  # git describe --tags
  realVersion = "1.4-12-g${builtins.substring 0 7 rev}";

  main_src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "prjtrellis";
    inherit rev;
    hash = "sha256-RyCZTdiF8kFBNGWJnwALjF0fXrZm3OvSM0sdL6ljlYU=";
    name = "trellis";
  };

  database_src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "prjtrellis-db";
    rev = "015e0330630d7c238c0e4f2cdd9c8157eb78c54a";
    hash = "sha256-1VpxI0RHZSiWdQPCgsEWQ3hqzy5F1YV7ZOGL3kK18XM=";
    name = "trellis-database";
  };

in
stdenv.mkDerivation {
  pname = "trellis";
  version = "unstable-2025-01-30";

  srcs = [
    main_src
    database_src
  ];
  sourceRoot = main_src.name;

  buildInputs = [ boost ];
  nativeBuildInputs = [
    cmake
    python3
  ];
  cmakeFlags = [
    "-DCURRENT_GIT_VERSION=${realVersion}"
    # TODO: should this be in stdenv instead?
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];

  preConfigure = ''
    rmdir database && ln -sfv ${database_src} ./database
    cd libtrellis
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for f in $out/bin/* ; do
      install_name_tool -change "$out/lib/libtrellis.dylib" "$out/lib/trellis/libtrellis.dylib" "$f"
    done
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/ecppack $out/share/trellis/misc/basecfgs/empty_lfe5u-85f.config /tmp/test.bin
  '';

  meta = {
    description = "Documentation and bitstream tools for Lattice ECP5 FPGAs";
    longDescription = ''
      Project Trellis documents the Lattice ECP5 architecture
      to enable development of open-source tools. Its goal is
      to provide sufficient information to develop a free and
      open Verilog to bitstream toolchain for these devices.
    '';
    homepage = "https://github.com/YosysHQ/prjtrellis";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      q3k
      thoughtpolice
      rowanG077
    ];
    platforms = lib.platforms.all;
  };
}
