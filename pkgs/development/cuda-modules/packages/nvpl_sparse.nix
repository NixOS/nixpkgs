{
  buildRedist,
  testers,
}:
buildRedist (finalAttrs: {
  redistName = "nvpl";
  pname = "nvpl_sparse";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # The archive's relative search prefix no longer applies after splitting outputs.
  postPatch = ''
    substituteInPlace lib/cmake/nvpl_sparse/nvpl_sparse-config.cmake \
      --replace-fail \
        'get_filename_component(_nvpl_sparse_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_sparse_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}/lib\")"
  '';

  passthru.tests.cmake = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "nvpl_sparse" ];
  };

  meta = {
    description = "Provides a set of CPU-accelerated basic linear algebra subroutines used for handling sparse matrices";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/sparse/release_notes.html";
  };
})
