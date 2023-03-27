{ stdenv
, intel-mpi
, pkg-config
, intel-mpi-devel-src
, rpmextract
}:
stdenv.mkDerivation rec {
  pname = "intel-mpi-test";
  version = intel-mpi.version;

  nativeBuildInputs = [ rpmextract pkg-config ];
  buildInputs = [ intel-mpi ];
  dontUnpack = true;

  env.test_exts = toString ["c" "cpp"];

  buildPhase = ''
    rpmextract ${intel-mpi-devel-src}
    cd opt/intel/oneapi/mpi/${version}/test

    # note that -lstdc++ is required for some reason, not sure why it's not auto-populated?

    # regular Nix build
    for ext in ''${test_exts[@]}; do
      gcc test.''${ext} -o test_''${ext}.exe $(pkg-config --cflags --libs impi) -lstdc++
    done

    # Clear Nix flags to only use pkg-config options
    for ext in ''${test_exts[@]}; do
      NIX_CFLAGS_COMPILE="" NIX_LDFLAGS="" gcc test.''${ext} -o test_''${ext}.exe $(pkg-config --cflags --libs impi) -lstdc++
    done
  '';

  # requires some output to be a successful derivation
  installPhase = ''
    echo "Success" > $out
  '';

  # TODO: tests require mpiexec.hydra to be running?
  # checkPhase = ''
  #   for ext in ''${test_exts[@]}; do
  #     mpiexec -n 1 -ppn 1 ./test_''${ext}.exe
  #   done
  # '';
}
