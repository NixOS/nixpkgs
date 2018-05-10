{ stdenv, fetchurl, cmake, git, swig, lua, itk }:

stdenv.mkDerivation rec {
  pname    = "simpleitk";
  version = "1.0.0";
  name  = "${pname}-${version}";

  src = fetchurl {
    url    = "https://sourceforge.net/projects/${pname}/files/SimpleITK/${version}/Source/SimpleITK-${version}.tar.gz";
    sha256 = "0554j0zp314zhs8isfg31fi6gvsl7xq3xjyyxkx1b1mjkn5qx673";
  };

  nativeBuildInputs = [ cmake git swig ];
  buildInputs = [ lua itk ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DCMAKE_CXX_FLAGS='-Wno-attributes'" ];

  checkPhase = "ctest";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.simpleitk.org;
    description = "Simplified interface to ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
