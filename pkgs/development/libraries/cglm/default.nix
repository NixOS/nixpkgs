{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "cglm";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "recp";
    repo = "cglm";
    rev = "v${version}";
    sha256 = "sha256-BzZb8NDgf1NnkZaaxs+0YlVuYod/uiWJxA3geaYN7e0=";
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
