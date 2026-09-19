{
  buildRedist,
  testers,
}:
buildRedist (finalAttrs: {
  redistName = "nvpl";
  pname = "nvpl_fft";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # The archive's relative search prefix no longer applies after splitting outputs.
  postPatch = ''
    substituteInPlace lib/cmake/nvpl_fft/nvpl_fft-config.cmake \
      --replace-fail \
        'get_filename_component(_nvpl_fft_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_fft_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}/lib\")"
  '';

  passthru.tests.cmake = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "nvpl_fft" ];
  };

  meta = {
    description = "Perform Fast Fourier Transform (FFT) calculations on ARM CPUs";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/fft/release_notes.html";
  };
})
