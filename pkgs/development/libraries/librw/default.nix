{ stdenv
, lib
, fetchFromGitHub
, glfw
, cmake
, withTools ? false
}:

stdenv.mkDerivation rec {
  pname = "librw";
  version = "unstable-2021-08-19";

  src = fetchFromGitHub {
    repo = pname;
    owner = "aap";
    rev = "5501c4fdc7425ff926be59369a13593bb6c81b54";
    sha256 = "z3hQ0PAlwfPfgM5oFwX8rMVc/IKLTo2fgFw1/nSH87I=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    glfw
  ];

  cmakeFlags = [
    "-DLIBRW_PLATFORM=GL3"
    "-DLIBRW_GL3_GFXLIB=GLFW"
    "-DLIBRW_INSTALL=ON"
    "-DLIBRW_EXAMPLES=OFF"
    "-DLIBRW_TOOLS=${if withTools then "ON" else "OFF"}"
  ];

  meta = with lib; {
    description = "A re-implementation of the RenderWare Graphics engine";
    homepage = "https://github.com/aap/librw";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
