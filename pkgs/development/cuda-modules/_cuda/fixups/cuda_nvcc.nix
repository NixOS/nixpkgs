{
  lib,
  backendStdenv,
  setupCudaHook,
}:
prevAttrs: {
  # Merge "bin" and "dev" into "out" to avoid circular references
  outputs = builtins.filter (
    x:
    !(builtins.elem x [
      "dev"
      "bin"
    ])
  ) prevAttrs.outputs or [ ];

  # Patch the nvcc.profile.
  # Syntax:
  # - `=` for assignment,
  # - `?=` for conditional assignment,
  # - `+=` to "prepend",
  # - `=+` to "append".

  # Cf. https://web.archive.org/web/20230308044351/https://arcb.csc.ncsu.edu/~mueller/cluster/nvidia/2.0/nvcc_2.0.pdf

  # We set all variables with the lowest priority (=+), but we do force
  # nvcc to use the fixed backend toolchain. Cf. comments in
  # backend-stdenv.nix

  postPatch =
    prevAttrs.postPatch or ""
    + ''
      substituteInPlace bin/nvcc.profile \
        --replace-fail \
          '$(TOP)/$(_TARGET_DIR_)/include' \
          "''${!outputDev}/include"
    ''
    + ''
      cat << EOF >> bin/nvcc.profile

      # Fix a compatible backend compiler
      PATH += "${backendStdenv.cc}/bin":

      # Expose the split-out nvvm
      LIBRARIES =+ "-L''${!outputBin}/nvvm/lib"
      INCLUDES =+ "-I''${!outputBin}/nvvm/include"
      EOF
    '';

  # Entries here will be in nativeBuildInputs when cuda_nvcc is in nativeBuildInputs.
  propagatedBuildInputs = prevAttrs.propagatedBuildInputs or [ ] ++ [ setupCudaHook ];

  postInstall = prevAttrs.postInstall or "" + ''
    moveToOutput "nvvm" "''${!outputBin}"
  '';

  # The nvcc and cicc binaries contain hard-coded references to /usr
  allowFHSReferences = true;

  meta = prevAttrs.meta or { } // {
    mainProgram = "nvcc";
  };
}
