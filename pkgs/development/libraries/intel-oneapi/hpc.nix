{
  lib,
  fetchurl,

  # The list of components to install;
  # Either [ "all" ], [ "default" ], or a custom list of components.
  # If you want to install all default components plus an extra one, pass [ "default" <your extra components here> ]
  # Note that changing this will also change the `buildInputs` of the derivation.
  #
  # If you want other components listed of the toolkit, consider using intel-oneapi.base instead;
  # This are specifically the components that are not present there.
  components ? [
    "intel.oneapi.lin.dpcpp-cpp-compiler"
    "intel.oneapi.lin.ifort-compiler"
    "intel.oneapi.lin.mpi.devel"
    "intel.oneapi.lin.tbb.devel"
  ],

  intel-oneapi,
  zlib,
  rdma-core,
  libpsm2,
  ucx,
  libuuid,
  numactl,
  level-zero,
  libffi,
}:
intel-oneapi.mkIntelOneApi (finalAttrs: {
  pname = "intel-oneapi-hpc-toolkit";

  src = fetchurl {
    url = "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/f59a79aa-4a6e-46e8-a6c2-be04bb13f274/intel-oneapi-hpc-toolkit-2025.3.1.55_offline.sh";
    hash = "sha256-NwLR7OWzmKYM05BZ2U7IZI+3IBnb0wiUgF+vHrX0Tro=";
  };

  versionYear = "2025";
  versionMajor = "3";
  versionMinor = "1";
  versionRel = "55";

  inherit components;

  depsByComponent = {
    mpi = [
      zlib
      rdma-core
      libpsm2
      ucx
      libuuid
      numactl
      level-zero
      libffi
    ];
    pti = [ level-zero ];
    ifort-compiler = [ ];
  };

  autoPatchelfIgnoreMissingDeps = [
    # Needs to be dynamically loaded as it depends on the hardware
    "libcuda.so.1"
  ];

  passthru.updateScript = intel-oneapi.mkUpdateScript {
    inherit (finalAttrs) pname;
    file = "hpc.nix";
    downloadPage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit-download.html?packages=hpc-toolkit&hpc-toolkit-os=linux&hpc-toolkit-lin=offline";
  };

  meta = {
    description = "Intel oneAPI HPC Toolkit";
    homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit.html";
    license = with lib.licenses; [
      intel-eula
      issl
      asl20
    ];
    maintainers = with lib.maintainers; [
      balsoft
    ];
    platforms = [ "x86_64-linux" ];
  };
})
