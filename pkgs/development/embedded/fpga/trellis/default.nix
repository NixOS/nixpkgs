{ lib, stdenv, fetchFromGitHub
, python3, boost
, cmake
}:

stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2021.07.06";

  # git describe --tags
  realVersion = with lib; with builtins;
    "1.0-482-g${substring 0 7 (elemAt srcs 0).rev}";

  srcs = [
    (fetchFromGitHub {
       owner  = "YosysHQ";
       repo   = "prjtrellis";
       rev    = "dff1cbcb1bd30de7e96f8a059f2e19be1bb2e44d";
       sha256 = "1gbrka9gqn124shx448aivbgywyp30zyjwfazr7v49lhrl7d46lb";
       name   = "trellis";
     })

    (fetchFromGitHub {
      owner  = "YosysHQ";
      repo   = "prjtrellis-db";
      rev    = "0ee729d20eaf9f1e0f1d657bc6452e3ffe6a0d63";
      sha256 = "0069c98bb4wilxz21snwc39yy0rm7ffma179djyz57d99p0vcfkq";
      name   = "trellis-database";
    })
  ];
  sourceRoot = "trellis";

  buildInputs = [ boost ];
  nativeBuildInputs = [ cmake python3 ];
  cmakeFlags = [
    "-DCURRENT_GIT_VERSION=${realVersion}"
    # TODO: should this be in stdenv instead?
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];

  preConfigure = with builtins; ''
    rmdir database && ln -sfv ${elemAt srcs 1} ./database

    source environment.sh
    cd libtrellis
  '';

  meta = with lib; {
    description     = "Documentation and bitstream tools for Lattice ECP5 FPGAs";
    longDescription = ''
      Project Trellis documents the Lattice ECP5 architecture
      to enable development of open-source tools. Its goal is
      to provide sufficient information to develop a free and
      open Verilog to bitstream toolchain for these devices.
    '';
    homepage    = "https://github.com/SymbiFlow/prjtrellis";
    license     = lib.licenses.isc;
    maintainers = with maintainers; [ q3k thoughtpolice emily ];
    platforms   = lib.platforms.all;
  };
}
