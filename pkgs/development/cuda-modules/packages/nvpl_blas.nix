{
  buildRedist,
  lib,
  stdenv,
}:
buildRedist {
  redistName = "nvpl";
  pname = "nvpl_blas";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # The OpenMP interface layer dlopens libgomp.so.1 by bare soname. Use the libgomp from stdenv, like the libstdc++
  # buildRedist provides: it's the one the rest of the process is built against, and libgomp is backward compatible.
  appendRunpaths = [ "${lib.getLib stdenv.cc.cc}/lib" ];

  # The CMake config finds headers and libraries with find_path(... NO_DEFAULT_PATH) relative to the config file itself,
  # which lives in a different output; point the search prefix at the include and lib outputs instead.
  postFixup = ''
    pushd "''${!outputDev:?}/lib/cmake/nvpl_blas" >/dev/null

    nixLog "patching $PWD/nvpl_blas-config.cmake to fix the search prefix"
    substituteInPlace "$PWD/nvpl_blas-config.cmake" \
      --replace-fail \
        'get_filename_component(_nvpl_blas_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_blas_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}\")"

    popd >/dev/null
  '';

  meta = {
    description = "Part of NVIDIA Performance Libraries that provides standard Fortran 77 BLAS APIs as well as C (CBLAS)";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/blas/release_notes.html";
  };
}
