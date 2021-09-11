{ lib
, stdenv
, fetchFromGitHub
, ruby
, opencl-headers
, addOpenGLRunpath
, autoreconfHook
}:
let
  version = "2.3.1";
in stdenv.mkDerivation {
  pname = "ocl-icd";
  inherit version;

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

  meta = with lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    homepage    = "https://github.com/OCL-dev/ocl-icd";
    license     = licenses.bsd2;
    platforms = platforms.unix;
  };
}
