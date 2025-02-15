{
  buildOctavePackage,
  stdenv,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "ocl";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-g/HLE0qjnzYkq3t3OhxFBpL250JWbWjHJBP0SYJSOZU=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/ocl/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Use OpenCL for parallelization";
    longDescription = ''
      Package using OpenCL for parallelization, mostly suitable to
      Single-Instruction-Multiple-Data (SIMD) computations, selectively
      using available OpenCL hardware and drivers.
    '';
    # error: structure has no member 'dir'
    broken = stdenv.hostPlatform.isDarwin;
  };
}
