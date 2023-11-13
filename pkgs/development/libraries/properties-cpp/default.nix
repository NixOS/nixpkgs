{ lib, stdenv
, fetchurl
, cmake
, pkg-config
, gtest
, doxygen
, graphviz
, lcov
}:

stdenv.mkDerivation rec {
  pname = "properties-cpp";
  version = "0.0.1";

  src = let srcver = "${version}+14.10.20140730"; in
    fetchurl {
      url = "https://launchpad.net/ubuntu/+archive/primary/+files/${pname}_${srcver}.orig.tar.gz";
      sha256 = "08vjyv7ibn6jh2ikj5v48kjpr3n6hlkp9qlvdn8r0vpiwzah0m2w";
    };

  postPatch = ''
    sed -i "/add_subdirectory(tests)/d" CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ gtest doxygen graphviz lcov ];

  meta = with lib; {
    homepage = "https://launchpad.net/properties-cpp";
    description = "A very simple convenience library for handling properties and signals in C++11";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ edwtjo ];
  };
}
