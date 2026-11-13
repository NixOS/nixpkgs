{ buildRedist, nvpl_blas }:
buildRedist {
  redistName = "nvpl";
  pname = "nvpl_tensor";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  buildInputs = [ nvpl_blas ];

  # The CMake config finds headers and libraries with find_path(... NO_DEFAULT_PATH) relative to the config file itself,
  # which lives in a different output; point the search prefix at the include and lib outputs instead.
  postFixup = ''
    pushd "''${!outputDev:?}/lib/cmake/nvpl_tensor" >/dev/null

    nixLog "patching $PWD/nvpl_tensor-config.cmake to fix the search prefix"
    substituteInPlace "$PWD/nvpl_tensor-config.cmake" \
      --replace-fail \
        'get_filename_component(_nvpl_tensor_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_tensor_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}\")"

    popd >/dev/null
  '';

  meta = {
    description = "Part of NVIDIA Performance Libraries that provides tensor primitives";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/tensor/release_notes.html";
  };
}
