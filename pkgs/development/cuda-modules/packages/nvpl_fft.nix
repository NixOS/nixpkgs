{ buildRedist }:
buildRedist {
  redistName = "nvpl";
  pname = "nvpl_fft";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # The CMake config finds headers and libraries with find_path(... NO_DEFAULT_PATH) relative to the config file itself,
  # which lives in a different output; point the search prefix at the include and lib outputs instead.
  postFixup = ''
    pushd "''${!outputDev:?}/lib/cmake/nvpl_fft" >/dev/null

    nixLog "patching $PWD/nvpl_fft-config.cmake to fix the search prefix"
    substituteInPlace "$PWD/nvpl_fft-config.cmake" \
      --replace-fail \
        'get_filename_component(_nvpl_fft_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_fft_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}\")"

    popd >/dev/null
  '';

  meta = {
    description = "Perform Fast Fourier Transform (FFT) calculations on ARM CPUs";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/fft/release_notes.html";
  };
}
