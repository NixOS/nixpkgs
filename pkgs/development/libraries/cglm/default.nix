{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "cglm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "recp";
    repo = "cglm";
    rev = "v${version}";
    sha256 = "sha256-V6qX6f1pETjDHVu+VJXRDcKKiCBYuQnh8Bz48HRyRR8=";
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
