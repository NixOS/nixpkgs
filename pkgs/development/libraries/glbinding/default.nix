{ stdenv, fetchFromGitHub, cmake, libGLU, xlibsWrapper }:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "glbinding";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "cginternals";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lvcps0n0p8gg0p2bkm5aq4b4kv8bvxlaaf4fcham2pgbgzil9d4";
  };

  buildInputs = [ cmake libGLU xlibsWrapper ];

  meta = with stdenv.lib; {
    homepage = https://github.com/cginternals/glbinding/;
    description = "A C++ binding for the OpenGL API, generated using the gl.xml specification";
    license = licenses.mit;
    maintainers = [ maintainers.mt-caret ];
  };
}
