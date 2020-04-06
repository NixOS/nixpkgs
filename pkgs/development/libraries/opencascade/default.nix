{ stdenv, fetchFromGitHub, fetchpatch, libGL, libGLU, libXmu, cmake, ninja,
  pkgconfig, fontconfig, freetype, expat, freeimage, vtk }:

stdenv.mkDerivation rec {
  pname = "opencascade-oce";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "oce";
    rev = "OCE-${version}";
    sha256 = "17wy8dcf44vqisishv1jjf3cmcxyygqq29y9c3wjdj983qi2hsig";
  };

  nativeBuildInputs = [ cmake ninja pkgconfig ];
  buildInputs = [ libGL libGLU libXmu freetype fontconfig expat freeimage vtk ];

  cmakeFlags = [
    "-DOCE_INSTALL_PREFIX=${placeholder "out"}"
    "-DOCE_WITH_FREEIMAGE=ON"
    "-DOCE_WITH_VTK=ON"
  ];

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
  ];

  postPatch = ''
    # make sure the installed cmake file uses absolute paths for fontconfig
    substituteInPlace adm/cmake/TKService/CMakeLists.txt \
      --replace FONTCONFIG_LIBRARIES FONTCONFIG_LINK_LIBRARIES
  '';

  meta = with stdenv.lib; {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = "https://github.com/tpaviot/oce";
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
