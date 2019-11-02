{stdenv, fetchurl, ruby, opencl-headers, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "ocl-icd";
  version = "2.2.10";

  src = fetchurl {
    url = "https://forge.imag.fr/frs/download.php/810/${pname}-${version}.tar.gz";
    sha256 = "0f14gpa13sdm0kzqv5yycp4pschbmi6n5fj7wl4ilspzsrqcgqr2";
  };

  nativeBuildInputs = [ ruby ];

  buildInputs = [ opencl-headers ];

  postPatch = ''
    sed -i 's,"/etc/OpenCL/vendors","${addOpenGLRunpath.driverLink}/etc/OpenCL/vendors",g' ocl_icd_loader.c
  '';

  meta = with stdenv.lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    homepage    = https://forge.imag.fr/projects/ocl-icd/;
    license     = licenses.bsd2;
    platforms = platforms.linux;
  };
}
