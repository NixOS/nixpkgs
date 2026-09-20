{
  buildRedist,
  testers,
  nvpl_blas,
}:
buildRedist (finalAttrs: {
  redistName = "nvpl";
  pname = "nvpl_tensor";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  propagatedBuildInputs = [ nvpl_blas ];

  # The archive's relative search prefix no longer applies after splitting outputs.
  postPatch = ''
    substituteInPlace lib/cmake/nvpl_tensor/nvpl_tensor-config.cmake \
      --replace-fail \
        'get_filename_component(_nvpl_tensor_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(_nvpl_tensor_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}/lib\")"
  '';

  passthru.tests.cmake = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "nvpl_tensor" ];
  };

  meta = {
    description = "Part of NVIDIA Performance Libraries that provides tensor primitives";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/tensor/release_notes.html";
  };
})
