{ stdenv, fetchurl, cmake, git, swig, lua, itk }:

stdenv.mkDerivation rec {
  pname    = "simpleitk";
  version = "1.1.0";
  name  = "${pname}-${version}";

  src = fetchurl {
    url    = "https://sourceforge.net/projects/${pname}/files/SimpleITK/${version}/Source/SimpleITK-${version}.tar.gz";
    sha256 = "01y8s73mw4yabqir2f8qp5zc1c0y6szi18rr4zwgsxz62g4drzgm";
  };

  nativeBuildInputs = [ cmake git swig ];
  buildInputs = [ lua itk ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DCMAKE_CXX_FLAGS='-Wno-attributes'" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.simpleitk.org;
    description = "Simplified interface to ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
