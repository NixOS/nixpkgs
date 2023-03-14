{ buildOctavePackage
, stdenv
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "ocl";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0ayi5x9zk9p4zm0qsr3i94lyp5468c9d1a7mqrqjqpdvkhrw0xnm";
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
    broken = stdenv.isDarwin;
  };
}
