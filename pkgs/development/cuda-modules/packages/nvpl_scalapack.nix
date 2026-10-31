{ buildRedist }:
buildRedist {
  redistName = "nvpl";
  pname = "nvpl_scalapack";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # The CMake config finds headers and libraries with find_path(... NO_DEFAULT_PATH) relative to the config file itself,
  # which lives in a different output; point the search prefix at the include and lib outputs instead.
  postFixup = ''
    pushd "''${!outputDev:?}/lib/cmake/nvpl_scalapack" >/dev/null

    nixLog "patching $PWD/nvpl_scalapack-config.cmake to fix the search prefix"
    substituteInPlace "$PWD/nvpl_scalapack-config.cmake" \
      --replace-fail \
        'get_filename_component(_nvpl_scalapack_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_scalapack_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}\")"

    popd >/dev/null
  '';

  meta = {
    description = "Provides an optimized implementation of ScaLAPACK for distributed-memory architectures";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/scalapack/release_notes.html";
  };
}
