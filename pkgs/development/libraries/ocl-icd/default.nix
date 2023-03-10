{ lib
, stdenv
, fetchFromGitHub
, ruby
, opencl-headers
, addOpenGLRunpath
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "ocl-icd";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "OCL-dev";
    repo = "ocl-icd";
    rev = "v${version}";
    sha256 = "1km2rqc9pw6xxkqp77a22pxfsb5kgw95w9zd15l5jgvyjb6rqqad";
  };

  nativeBuildInputs = [
    autoreconfHook
    ruby
  ];

  buildInputs = [ opencl-headers ];

  configureFlags = [
    "--enable-custom-vendordir=/run/opengl-driver/etc/OpenCL/vendors"
  ];

  meta = with lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    homepage    = "https://github.com/OCL-dev/ocl-icd";
    license     = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
