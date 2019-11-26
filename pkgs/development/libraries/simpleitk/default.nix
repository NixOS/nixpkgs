{ stdenv, fetchFromGitHub, cmake, git, swig, lua, itk, tcl, tk }:

stdenv.mkDerivation rec {
  pname = "simpleitk";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    rev = "v${version}";
    sha256 = "0nmsq0qx4jmrrhrc6bfm11wwvyszvfgl45xizw69yra3cv9pgmm6";
  };

  nativeBuildInputs = [ cmake git swig ];
  buildInputs = [ lua itk ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DCMAKE_CXX_FLAGS='-Wno-attributes'" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.simpleitk.org;
    description = "Simplified interface to ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
