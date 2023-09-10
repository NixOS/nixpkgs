{ lib, makeImpureTest, clinfo, rocm-opencl-icd, rocm-smi }:
makeImpureTest {
  name = "rocm-opencl";
  testedPackage = "rocm-opencl-icd";

  nativeBuildInputs = [ clinfo rocm-smi ];

  OCL_ICD_VENDORS = "${rocm-opencl-icd}/etc/OpenCL/vendors/";

  testScript = ''
    # Test fails if the number of platforms is 0
    clinfo | grep -E 'Number of platforms * [1-9]'
    rocm-smi | grep -A1 GPU
  '';

  meta = with lib; {
    maintainers = teams.rocm.members;
  };
}
