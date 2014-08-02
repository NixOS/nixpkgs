{ stdenv, fetchurl, unzip, cmake}:

stdenv.mkDerivation rec {
  version = "1.7.0";
  name = "gtest-${version}";

  src = fetchurl {
    url = "https://googletest.googlecode.com/files/${name}.zip";
    sha256="03fnw3bizw9bcx7l5qy1vz7185g33d5pxqcb6aqxwlrzv26s2z14";
  };

  buildInputs = [ unzip cmake ];

  configurePhase = ''
    mkdir build
    cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v libgtest.a libgtest_main.a $out/lib
    cp -v -r ../include $out
    cp -v -r ../src $out
  '';

  meta = {
    description = "Google test: Google's framework for writing C++ tests.";
    homepage = https://code.google.com/p/googletest/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.zoomulator ];
  };
}

