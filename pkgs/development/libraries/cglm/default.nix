{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "cglm";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "recp";
    repo = "cglm";
    rev = "v${version}";
    sha256 = "sha256-e90N8bHFt3dOzppa4xkB7qra7/bHhAexTEYGXPFXS4s=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '\$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = with lib; {
    homepage = "https://github.com/recp/cglm";
    description = "Highly Optimized Graphics Math (glm) for C";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.unix;
  };
}
