{
  buildRedist,
  testers,
  nvpl_blas,
}:
buildRedist (finalAttrs: {
  redistName = "nvpl";
  pname = "nvpl_lapack";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  propagatedBuildInputs = [ nvpl_blas ];

  # The archive's relative search prefix no longer applies after splitting outputs.
  postPatch = ''
    substituteInPlace lib/cmake/nvpl_lapack/nvpl_lapack-config.cmake \
      --replace-fail \
        'get_filename_component(_nvpl_lapack_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_lapack_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}/lib\")"
  '';

  passthru.tests.cmake = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "nvpl_lapack" ];
  };

  meta = {
    description = "Part of NVIDIA Performance Libraries that provides standard Fortran 90 LAPACK and LAPACKE APIs";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/lapack/release_notes.html";
  };
})
