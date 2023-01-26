{ lib, stdenv, fetchFromGitHub, fetchpatch, libGL, libGLU, libXmu, cmake, ninja,
  pkg-config, fontconfig, freetype, expat, freeimage, vtk, gl2ps, tbb,
  OpenCL, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "opencascade-oce";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "oce";
    rev = "OCE-${version}";
    sha256 = "17wy8dcf44vqisishv1jjf3cmcxyygqq29y9c3wjdj983qi2hsig";
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [
    libGL libGLU libXmu freetype fontconfig expat freeimage vtk
    gl2ps tbb
  ]
    ++ lib.optionals stdenv.isDarwin [OpenCL Cocoa]
  ;

  cmakeFlags = [
    "-DOCE_INSTALL_PREFIX=${placeholder "out"}"
    "-DOCE_WITH_FREEIMAGE=ON"
    "-DOCE_WITH_VTK=ON"
    "-DOCE_WITH_GL2PS=ON"
    "-DOCE_MULTITHREAD_LIBRARY=TBB"
  ]
  ++ lib.optionals stdenv.isDarwin ["-DOCE_OSX_USE_COCOA=ON" "-DOCE_WITH_OPENCL=ON"];

  patches = [
    # Use fontconfig instead of hardcoded directory list
    # https://github.com/tpaviot/oce/pull/714
    (fetchpatch {
      url = "https://github.com/tpaviot/oce/commit/9643432b27fec8974ca0ee15c3c372f5fe8fc069.patch";
      sha256 = "1wd940rszmh5apcpk5fv6126h8mcjcy4rjifrql5d4ac90v06v4c";
    })
    # Fix for glibc 2.26
    (fetchpatch {
      url = "https://github.com/tpaviot/oce/commit/3b44656e93270d782009b06ec4be84d2a13f8126.patch";
      sha256 = "1ccakkcwy5g0184m23x0mnh22i0lk45xm8kgiv5z3pl7nh35dh8k";
    })
    (fetchpatch {
      url = "https://github.com/tpaviot/oce/commit/cf50d078cd5fac03a48fd204938bd240930a08dc.patch";
      sha256 = "1xv94hcvggmb1c8vqwic1aiw9jw1sxk8mqbaak9xs9ycfqdvgdyc";
    })
  ];

  postPatch = ''
    # make sure the installed cmake file uses absolute paths for fontconfig
    substituteInPlace adm/cmake/TKService/CMakeLists.txt \
      --replace FONTCONFIG_LIBRARIES FONTCONFIG_LINK_LIBRARIES
  '';

  meta = with lib; {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = "https://github.com/tpaviot/oce";
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
