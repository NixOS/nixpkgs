{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "ocl";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-ymahtzdCX4D3rBMThUmhWOY238yckP0bmNE0xFhK0No=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/ocl/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Use OpenCL for parallelization";
    longDescription = ''
      Package using OpenCL for parallelization, mostly suitable to
      Single-Instruction-Multiple-Data (SIMD) computations, selectively
      using available OpenCL hardware and drivers.
    '';
  };
}
