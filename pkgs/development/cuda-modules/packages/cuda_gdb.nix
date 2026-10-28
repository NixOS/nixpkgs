{
  backendStdenv,
  buildRedist,
  cudaAtLeast,
  expat,
  gmp,
  lib,
  libxcrypt-legacy,
  ncurses,
  python3,
}:
let
  python3MajorMinorVersion = lib.versions.majorMinor python3.version;
in
buildRedist {
  redistName = "cuda";
  pname = "cuda_gdb";

  outputs = [
    "out"
    "bin"
  ];

  allowFHSReferences = true;

  buildInputs =
    # only needs gmp from 12.0 and on
    lib.optionals (cudaAtLeast "12.0") [ gmp ]
    # aarch64, sbsa needs expat
    ++ lib.optionals backendStdenv.hostPlatform.isAarch64 [ expat ]
    # From 12.5, cuda-gdb comes with Python TUI wrappers
    ++ lib.optionals (cudaAtLeast "12.5") [
      libxcrypt-legacy
      ncurses
      python3
    ];

  # Remove binaries requiring Python3 versions we do not have
  postInstall = lib.optionalString (cudaAtLeast "12.5") ''
    pushd "''${!outputBin}/bin" >/dev/null
    nixLog "removing cuda-gdb-python*-tui binaries for Python 3 versions other than ${python3MajorMinorVersion}"
    for pygdb in cuda-gdb-python*-tui; do
      if [[ "$pygdb" == "cuda-gdb-python${python3MajorMinorVersion}-tui" ]]; then
        continue
      fi
      nixLog "removing $pygdb"
      rm -rf "$pygdb"
    done
    unset -v pygdb
    popd >/dev/null
  '';

  brokenAssertions = [
    {
      # TODO(@connorbaker): Figure out which are supported.
      message = "python 3 version is supported";
      assertion = true;
    }
  ];

  meta = {
    description = "NVIDIA tool for debugging CUDA applications on Linux and QNX systems";
    longDescription = ''
      CUDA-GDB is the NVIDIA tool for debugging CUDA applications running on Linux and QNX. CUDA-GDB is an extension
      to GDB, the GNU Project debugger. The tool provides developers with a mechanism for debugging CUDA
      applications running on actual hardware.
    '';
    homepage = "https://docs.nvidia.com/cuda/cuda-gdb";
    changelog = "https://docs.nvidia.com/cuda/cuda-gdb#release-notes";
  };
}
