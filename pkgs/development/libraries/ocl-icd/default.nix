{ stdenv, fetchFromGitHub, addOpenGLRunpath, autoconf, automake, libtool, opencl-headers, ruby }:

stdenv.mkDerivation rec {
  name = "ocl-icd-${version}";
  version = "2.2.10";

  src = fetchFromGitHub {
    owner = "OCL-dev";
    repo = "ocl-icd";
    rev = "v${version}";
    sha256 = "1cvay1lif71v60hhgyicc25ysy9ifh3da1gp12ri5klyvx4jj3ji";
  };

  nativeBuildInputs = [ addOpenGLRunpath autoconf automake libtool ruby ];

  buildInputs = [ opencl-headers ];

  postPatch = ''
    sed -i 's,"/etc/OpenCL/vendors","${addOpenGLRunpath.driverLink}/etc/OpenCL/vendors",g' ocl_icd_loader.c
  '';

  preConfigure = "./bootstrap";

  # Set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = ''
    addOpenGLRunpath $out/lib/libOpenCL.so
  '';

  meta = with stdenv.lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    homepage    = https://github.com/OCL-dev/ocl-icd;
    license     = licenses.bsd2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ gloaming ];
  };
}
