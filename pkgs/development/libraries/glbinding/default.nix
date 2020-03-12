{ stdenv, fetchFromGitHub, cmake, libGLU, xlibsWrapper }:
stdenv.mkDerivation rec {
  pname = "glbinding";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "cginternals";
    repo = pname;
    rev = "v${version}";
    sha256 = "1avd7ssms11xx7h0cm8h4pfpk55f07f1j1ybykxfgsym2chb2z08";
  };

  buildInputs = [ cmake libGLU xlibsWrapper ];

  meta = with stdenv.lib; {
    homepage = https://github.com/cginternals/glbinding/;
    description = "A C++ binding for the OpenGL API, generated using the gl.xml specification";
    license = licenses.mit;
    maintainers = [ maintainers.mt-caret ];
  };
}
