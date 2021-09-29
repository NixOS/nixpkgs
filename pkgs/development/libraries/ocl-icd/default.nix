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
  version = "2.2.10";

  src = fetchFromGitHub {
    owner = "OCL-dev";
    repo = "ocl-icd";
    rev = "v${version}";
    sha256 = "1cvay1lif71v60hhgyicc25ysy9ifh3da1gp12ri5klyvx4jj3ji";
  };

  nativeBuildInputs = [
    autoreconfHook
    ruby
  ];

  buildInputs = [ opencl-headers ];

  postPatch = ''
    sed -i 's,"/etc/OpenCL/vendors","${addOpenGLRunpath.driverLink}/etc/OpenCL/vendors",g' ocl_icd_loader.c
  '';

  meta = with lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    homepage    = "https://github.com/OCL-dev/ocl-icd";
    license     = licenses.bsd2;
    platforms = platforms.linux;
  };
}
