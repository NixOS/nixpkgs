{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvvm";

  # NOTE(@connorbaker): CMake and other build systems may not react well to this library being split into multiple
  # outputs; they may use relative path accesses.
  outputs = [ "out" ];

  # Everything is nested under the nvvm directory.
  prePatch = ''
    nixLog "un-nesting top-level $PWD/nvvm directory"
    mv -v "$PWD/nvvm"/* "$PWD/"
    nixLog "removing empty $PWD/nvvm directory"
    rmdir -v "$PWD/nvvm"
  '';

  meta = {
    description = "Interface for generating PTX code from both binary and text NVVM IR inputs";
    longDescription = ''
      libNVVM API provides an interface for generating PTX code from both binary and text NVVM IR inputs.
    '';
    homepage = "https://docs.nvidia.com/cuda/libnvvm-api";
  };
}
