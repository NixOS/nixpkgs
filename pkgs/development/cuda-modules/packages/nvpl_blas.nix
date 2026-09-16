{
  buildRedist,
  testers,
}:
buildRedist (finalAttrs: {
  redistName = "nvpl";
  pname = "nvpl_blas";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # The archive's relative search prefix no longer applies after splitting outputs.
  postPatch = ''
    substituteInPlace lib/cmake/nvpl_blas/nvpl_blas-config.cmake \
      --replace-fail \
        'get_filename_component(_nvpl_blas_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_blas_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}/lib\")"
  '';

  passthru.tests.cmake = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "nvpl_blas" ];
  };

  passthru.tests.cmake-mapped-outputs = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage.overrideAttrs {
      outputs = [
        "out"
        "dev"
        "bin"
      ];
      outputInclude = "bin";
      outputLib = "out";
    };
    moduleNames = [ "nvpl_blas" ];
  };

  meta = {
    description = "Part of NVIDIA Performance Libraries that provides standard Fortran 77 BLAS APIs as well as C (CBLAS)";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/blas/release_notes.html";
  };
})
