{
  buildRedist,
  testers,
}:
buildRedist (finalAttrs: {
  redistName = "nvpl";
  pname = "nvpl_common";

  outputs = [
    "out"
    "dev"
  ];

  passthru.tests.cmake = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [
      "nvpl_common"
      "nvpl"
    ];
  };

  meta = {
    description = "Common part of NVIDIA Performance Libraries";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/release_notes.html";
  };
})
