{ stdenv, fetchFromGitHub, cmake, git, swig, lua, itk, tcl, tk }:

stdenv.mkDerivation rec {
  pname = "simpleitk";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    rev = "v${version}";
    sha256 = "0dvf2407z9n6lczm0l5vzcvpw6r6z1wzrs2gk3dqjrgynq6952qr";
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
