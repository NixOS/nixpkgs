{
  cudaAtLeast,
  expat,
  gmp,
  lib,
  libxcrypt-legacy,
  ncurses,
  python3,
  stdenv,
}:
let
  python3MajorMinorVersion = lib.versions.majorMinor python3.version;
in
prevAttrs: {
  allowFHSReferences = true;

  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [ gmp ]
    # aarch64, sbsa needs expat
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [ expat ]
    # From 12.5, cuda-gdb comes with Python TUI wrappers
    ++ lib.optionals (cudaAtLeast "12.5") [
      libxcrypt-legacy
      ncurses
      python3
    ];

  postInstall =
    prevAttrs.postInstall or ""
    # Remove binaries requiring Python3 versions we do not have
    + lib.optionalString (cudaAtLeast "12.5") ''
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

  passthru = prevAttrs.passthru or { } // {
    brokenAssertions = prevAttrs.passthru.brokenAssertions or [ ] ++ [
      {
        # TODO(@connorbaker): Figure out which are supported.
        message = "python 3 version is supported";
        assertion = true;
      }
    ];

    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "bin"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "NVIDIA tool for debugging CUDA applications on Linux and QNX systems";
    longDescription = ''
      CUDA-GDB is the NVIDIA tool for debugging CUDA applications running on Linux and QNX. CUDA-GDB is an extension
      to GDB, the GNU Project debugger. The tool provides developers with a mechanism for debugging CUDA
      applications running on actual hardware.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/cuda-gdb";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_gdb";
    changelog = "https://docs.nvidia.com/cuda/cuda-gdb#release-notes";
  };
}
