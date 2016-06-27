{ stdenv, fetchurl,
  clang,
  cmake
}:

let
  version = "1.7";
in
stdenv.mkDerivation rec {
  name = "libobjc2-${version}";
  src = fetchurl {
    url = "http://download.gna.org/gnustep/libobjc2-1.7.tar.bz2";
    sha256 = "1h9wkm1x9wrzd3alm99bx710lrs9nb8h2x5jpxbqwgbgzzv4l6rs";
  };
  buildInputs = [ clang cmake ];

  # since we don't support Objective-C++, we don't interoperate
  # with C++ either
  patches = [ ./removeCXXtests.patch ];
  
  # build phase:
  # mkdir Build
  # cd Build
  # cmake ..
  # make -j8
  # make install
  #
  # probably useful:
  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];
  #
  # cmakeDir = "../src"; # Build?
#  postInstall = ''
#    mkdir Build
#    cd Build
#    cmake -DCMAKE_INSTALL_PREFIX=$out -DGNUSTEP_INSTALL_TYPE=NONE ..
#    make install
#  '';

  meta = {
    description = "Objective-C runtime for use with GNUstep";
  
    homepage = http://gnustep.org/;
  
    license = stdenv.lib.licenses.mit;
  
    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.all;
  };
}