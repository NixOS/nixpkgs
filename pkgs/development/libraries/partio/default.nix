{ stdenv, fetchFromGitHub, unzip, cmake, freeglut, mesa, zlib, swig, python, doxygen, xorg }:

stdenv.mkDerivation rec
{
  name = "partio-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "partio";
    rev = "v${version}";
    sha256 = "0z7n5ay21ca7g7xb80v6jmr96x9k7vm7zawawvmx71yj32rg1n34";
  };

  outputs = [ "dev" "out" "lib" ];

  buildInputs = [ unzip cmake freeglut mesa zlib swig python doxygen xorg.libXi xorg.libXmu ];

  enableParallelBuilding = true;

  buildPhase = ''
    sed 's/ADD_LIBRARY (partio /ADD_LIBRARY (partio SHARED /' -i ../src/lib/CMakeLists.txt
    CXXFLAGS="-std=c++11" cmake .
    make partio

    mkdir $dev
    mkdir -p $lib/lib
    mkdir $out
      '';

  # TODO:
  # Sexpr support

  installPhase = ''
    mkdir $dev/lib
    mkdir -p $dev/include/partio

    mv lib/libpartio.so $lib/lib

    mv ../src/lib/* $dev/include/partio
  '';

  meta = with stdenv.lib; {
    description = "C++ (with python bindings) library for easily reading/writing/manipulating common animation particle formats such as PDB, BGEO, PTC";
    homepage = "https://www.disneyanimation.com/technology/partio.html";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
