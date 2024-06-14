{
  addDriverRunpath,
  cuda_cccl ? null,
  cuda_nvcc,
  lib,
  utils,
}:
let
  inherit (lib.strings) optionalString;
  inherit (utils) assertMsgOutputIsPresent;
in
finalAttrs: prevAttrs: {
  # The libcuda stub's pkg-config doesn't follow the general pattern:
  postPatch =
    prevAttrs.postPatch or ""
    + ''
      while IFS= read -r -d $'\0' path; do
        sed -i \
          -e "s|^libdir\s*=.*/lib\$|libdir=''${!outputLib}/lib/stubs|" \
          -e "s|^Libs\s*:\(.*\)\$|Libs: \1 -Wl,-rpath,${addDriverRunpath.driverLink}/lib|" \
          "$path"
      done < <(find -iname 'cuda-*.pc' -print0)
    ''
    # Namelink may not be enough, add a soname.
    # Cf. https://gitlab.kitware.com/cmake/cmake/-/issues/25536
    + ''
      if [[ -f lib/stubs/libcuda.so && ! -f lib/stubs/libcuda.so.1 ]]; then
        ln -s libcuda.so lib/stubs/libcuda.so.1
      fi
    '';

  postInstall =
    (prevAttrs.postInstall or "")
    # NOTE: We can't patch a single output with overrideAttrs, so we need to use nix-support.
    # NOTE: Make sure to guard against the assert running when the package isn't available.
    + optionalString finalAttrs.finalPackage.meta.available (
      (
        assert assertMsgOutputIsPresent finalAttrs.name "dev" finalAttrs;
        ''
          mkdir -p "$dev/nix-support"
        ''
      )
      # cuda_cudart.dev depends on crt/host_config.h, which is from cuda_nvcc.dev.
      + optionalString cuda_nvcc.meta.available (
        assert assertMsgOutputIsPresent finalAttrs.name "dev" cuda_nvcc;
        ''
          printWords "${cuda_nvcc.dev}" >> "$dev/nix-support/propagated-build-inputs"
        ''
      )
      # cuda_cuadrt.dev has include/cuda_fp16.h which requires cuda_cccl.dev's include/nv/target
      + optionalString (cuda_cccl != null && cuda_cccl.meta.available) (
        assert assertMsgOutputIsPresent finalAttrs.name "dev" cuda_cccl;
        ''
          printWords "${cuda_cccl.dev}" >> "$dev/nix-support/propagated-build-inputs"
        ''
      )
    );
}
