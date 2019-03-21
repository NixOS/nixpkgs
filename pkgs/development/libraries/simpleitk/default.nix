{ stdenv, fetchurl, cmake, git, swig, lua, itk }:

stdenv.mkDerivation rec {
  pname    = "simpleitk";
  version = "1.2.0";
  name  = "${pname}-${version}";

  src = fetchurl {
    url    = "https://sourceforge.net/projects/${pname}/files/SimpleITK/${version}/Source/SimpleITK-${version}.tar.gz";
    sha256 = "10lxsr0144li6bmfgs646cvczczqkgmvvs3ndds66q8lg9zwbnky";
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
