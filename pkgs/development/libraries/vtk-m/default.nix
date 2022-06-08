{ stdenv
, lib
, fetchFromGitLab
, cmake
# , diy
}:

stdenv.mkDerivation rec {
  pname = "VTK-m";
  version = "1.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "vtk";
    repo = "vtk-m";
    rev = "v${version}";
    sha256 = "kkHc2ny+KjzgfaehoulaUfetx5y/dezyHd93mULElxs=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    # diy
  ];

  cmakeFlags = [
    # Currently not supported:
    # "-DVTKM_USE_EXTERNAL_DIY:BOOL=ON"
  ];

  meta = with lib; {
    description = "A toolkit of scientific visualization algorithms for emerging processor architectures";
    homepage = "https://m.vtk.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
