{
  buildRedist,
  testers,
  nvpl_blas,
  nvpl_lapack,
}:
buildRedist (finalAttrs: {
  redistName = "nvpl";
  pname = "nvpl_scalapack";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  propagatedBuildInputs = [
    nvpl_blas
    nvpl_lapack
  ];

  # The archive's relative search prefix no longer applies after splitting outputs.
  postPatch = ''
    substituteInPlace lib/cmake/nvpl_scalapack/nvpl_scalapack-config.cmake \
      --replace-fail \
        'get_filename_component(_nvpl_scalapack_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_scalapack_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}/lib\")"
  '';

  passthru.tests.cmake = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "nvpl_scalapack" ];
  };

  meta = {
    description = "Provides an optimized implementation of ScaLAPACK for distributed-memory architectures";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/scalapack/release_notes.html";
  };
})
