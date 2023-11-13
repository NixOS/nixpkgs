{ lib, stdenv, fetchFromGitHub, python3, boost, cmake }:

let
  rev = "488f4e71073062de314c55a037ede7cf03a3324c";
  # git describe --tags
  realVersion = "1.2.1-14-g${builtins.substring 0 7 rev}";

  main_src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "prjtrellis";
    inherit rev;
    hash   = "sha256-Blbu+0rlM/3izbF0XCvkNpSAND0IclWEwK7anzyrpvw=";
    name   = "trellis";
  };

  database_src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "prjtrellis-db";
    rev    = "35d900a94ff0db152679a67bf6e4fbf40ebc34aa";
    hash   = "sha256-r6viR8y9ZjURGNbsa0/YY8lzy9kGzjuu408ntxwpqm0=";
    name   = "trellis-database";
  };

in stdenv.mkDerivation rec {
  pname = "trellis";
  version = "unstable-2022-09-14";

  srcs = [ main_src database_src ];
  sourceRoot = main_src.name;

  buildInputs = [ boost ];
  nativeBuildInputs = [ cmake python3 ];
  cmakeFlags = [
    "-DCURRENT_GIT_VERSION=${realVersion}"
    # TODO: should this be in stdenv instead?
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];

  preConfigure = ''
    rmdir database && ln -sfv ${database_src} ./database

    cd libtrellis
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    for f in $out/bin/* ; do
      install_name_tool -change "$out/lib/libtrellis.dylib" "$out/lib/trellis/libtrellis.dylib" "$f"
    done
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/ecppack $out/share/trellis/misc/basecfgs/empty_lfe5u-85f.config /tmp/test.bin
  '';

  meta = with lib; {
    description     = "Documentation and bitstream tools for Lattice ECP5 FPGAs";
    longDescription = ''
      Project Trellis documents the Lattice ECP5 architecture
      to enable development of open-source tools. Its goal is
      to provide sufficient information to develop a free and
      open Verilog to bitstream toolchain for these devices.
    '';
    homepage    = "https://github.com/YosysHQ/prjtrellis";
    license     = licenses.isc;
    maintainers = with maintainers; [ q3k thoughtpolice emily rowanG077 ];
    platforms   = platforms.all;
  };
}
