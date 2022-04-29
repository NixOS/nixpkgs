{ lib, stdenv, fetchFromGitHub, python3, boost, cmake }:

let
  rev = "2f06397673bbca3da11928d538b8ab7d01c944c6";
  # git describe --tags
  realVersion = "1.0-534-g${builtins.substring 0 7 rev}";
in stdenv.mkDerivation rec {
  pname = "trellis";
  version = "2021-12-14";

  srcs = [
    (fetchFromGitHub {
       owner  = "YosysHQ";
       repo   = "prjtrellis";
       inherit rev;
       hash   = "sha256-m5CalAIbzY2bhOvpBbPBeLZeDp+itk1HlRsSmtiddaA=";
       name   = "trellis";
     })

    (fetchFromGitHub {
      owner  = "YosysHQ";
      repo   = "prjtrellis-db";
      # note: the upstream submodule points to revision 0ee729d20eaf,
      # but that's just the tip of the branch that was merged into master.
      # fdf4bf275a is the merge commit itself
      rev    = "fdf4bf275a7402654bc643db537173e2fbc86103";
      sha256 = "eDq2wU2pnfK9bOkEVZ07NQPv02Dc6iB+p5GTtVBiyQA=";
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

  preConfigure = ''
    rmdir database && ln -sfv ${builtins.elemAt srcs 1} ./database

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
