{ stdenv
, lib
, fetchFromGitHub
, glfw
, cmake
, withTools ? false
}:

stdenv.mkDerivation rec {
  pname = "librw";
  version = "unstable-2021-07-09";

  src = fetchFromGitHub {
    repo = pname;
    owner = "aap";
    rev = "b164e49dcfe5547e2cb9da51be1cbdc9ae4e1829";
    sha256 = "Wgdu0PuszqPHyTsg0amzalYNVdCsrHOeO6Wzb0fCmig=";
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
