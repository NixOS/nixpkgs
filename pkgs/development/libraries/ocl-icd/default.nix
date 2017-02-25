{stdenv, fetchurl, ruby, opencl-headers, mesa_noglu }:

stdenv.mkDerivation rec {
  name = "ocl-icd-${version}";
  version = "2.2.10";

  src = fetchurl {
    url = "https://forge.imag.fr/frs/download.php/810/${name}.tar.gz";
    sha256 = "0f14gpa13sdm0kzqv5yycp4pschbmi6n5fj7wl4ilspzsrqcgqr2";
  };

  buildInputs = [ ruby opencl-headers ];

  postPatch = ''
    sed -i 's,"/etc/OpenCL/vendors","${mesa_noglu.driverLink}/etc/OpenCL/vendors",g' ocl_icd_loader.c
  '';

  meta = with stdenv.lib; {
    description = "OpenCL ICD Loader";
    homepage    = https://forge.imag.fr/projects/ocl-icd/;
    license     = licenses.bsd2;
    platforms = platforms.linux;
  };
}
