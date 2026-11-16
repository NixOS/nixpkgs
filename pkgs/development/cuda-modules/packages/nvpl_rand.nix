{ buildRedist }:
buildRedist {
  redistName = "nvpl";
  pname = "nvpl_rand";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # The CMake config finds headers and libraries with find_path(... NO_DEFAULT_PATH) relative to the config file itself,
  # which lives in a different output; point the search prefix at the include and lib outputs instead.
  postFixup = ''
    pushd "''${!outputDev:?}/lib/cmake/nvpl_rand" >/dev/null

    nixLog "patching $PWD/nvpl_rand-config.cmake to fix the search prefix"
    substituteInPlace "$PWD/nvpl_rand-config.cmake" \
      --replace-fail \
        'get_filename_component(nvpl_rand_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(nvpl_rand_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}\")"

    popd >/dev/null
  '';

  meta = {
    description = "Collection of efficient pseudorandom and quasirandom number generators for ARM CPUs";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/rand/release_notes.html";
  };
}
