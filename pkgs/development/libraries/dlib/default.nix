{ stdenv, fetchurl, cmake, xlibsWrapper }:

stdenv.mkDerivation rec {
  version = "18.10";
  name = "dlib-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dclib/dlib/${name}.tar.bz2";
    sha256 = "1g3v13azc29m5r7zqs3x0g731hny6spb66cxnra7f167z31ka3s7";
  };

  # The supplied CMakeLists.txt does not have any install targets.
  sources_var = "\$\{sources\}";
  headers_var = "\$\{hearders\}";
  preConfigure = ''
    cat << EOF > CMakeLists.txt
    cmake_minimum_required(VERSION 2.6 FATAL_ERROR)
    project(dlib)

    include_directories(./)

    file(GLOB sources ./dlib/all/*.cpp)
    file(GLOB headers ./dlib/*.h)

    SET(LIBRARY_OUTPUT_PATH ".")
    add_library(dlib "SHARED" dlib/all/source.cpp ${sources_var} ${headers_var})

    install(TARGETS dlib DESTINATION lib)
    install(DIRECTORY dlib/ DESTINATION include/dlib FILES_MATCHING PATTERN "*.h")
    EOF
  '';   

  enableParallelBuilding = true;
  buildInputs = [ cmake xlibsWrapper ];
  propagatedBuildInputs = [ xlibsWrapper ];

  meta = with stdenv.lib; {
    description = "A general purpose cross-platform C++ machine learning library";
    homepage = http://www.dlib.net;
    license = stdenv.lib.licenses.boost;
    maintainers = with maintainers; [ christopherpoole ];
    platforms = stdenv.lib.platforms.all;
  };
}

