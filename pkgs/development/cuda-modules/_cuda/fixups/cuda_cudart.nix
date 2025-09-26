# TODO(@connorbaker): cuda_cudart.dev depends on crt/host_config.h, which is from
# (getDev cuda_nvcc). It would be nice to be able to encode that.
{ addDriverRunpath, lib }:
prevAttrs: {
  # Remove once cuda-find-redist-features has a special case for libcuda
  outputs =
    prevAttrs.outputs or [ ]
    ++ lib.lists.optionals (!(builtins.elem "stubs" prevAttrs.outputs)) [ "stubs" ];

  allowFHSReferences = false;

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

  postFixup = prevAttrs.postFixup or "" + ''
    mv "''${!outputDev}/share" "''${!outputDev}/lib"
    moveToOutput lib/stubs "$stubs"
    ln -s "$stubs"/lib/stubs/* "$stubs"/lib/
    ln -s "$stubs"/lib/stubs "''${!outputLib}/lib/stubs"
  '';
}
