{
  buildRedist,
  testers,
}:
buildRedist (finalAttrs: {
  redistName = "nvpl";
  pname = "nvpl_rand";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # The archive's relative search prefix no longer applies after splitting outputs.
  postPatch = ''
    substituteInPlace lib/cmake/nvpl_rand/nvpl_rand-config.cmake \
      --replace-fail \
        'get_filename_component(nvpl_rand_search_prefix "''${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)' \
        "set(nvpl_rand_search_prefix \"''${!outputInclude:?}/include;''${!outputLib:?}/lib\")"
  '';

  passthru.tests.cmake = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "nvpl_rand" ];
  };

  meta = {
    description = "Collection of efficient pseudorandom and quasirandom number generators for ARM CPUs";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/rand/release_notes.html";
  };
})
