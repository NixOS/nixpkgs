{ stdenv, fetchFromGitHub, cmake, libGLU, xlibsWrapper }:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "glbinding";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "cginternals";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yic3p2iqzxc7wrjnqclx7vcaaqx5fiysq9rqbi6v390jqkg3zlz";
  };

  buildInputs = [ cmake libGLU xlibsWrapper ];

  meta = with stdenv.lib; {
    homepage = https://github.com/cginternals/glbinding/;
    description = "A C++ binding for the OpenGL API, generated using the gl.xml specification";
    license = licenses.mit;
    maintainers = [ maintainers.mt-caret ];
  };
}
