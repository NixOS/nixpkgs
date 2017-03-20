{ stdenv, fetchurl, unzip, cmake }:

stdenv.mkDerivation rec {
  version = "0.9.8.4";
  name = "glm-${version}";

  src = fetchurl {
    url = "https://github.com/g-truc/glm/releases/download/${version}/${name}.zip";
    sha256 = "1c9cflvx0b16qxh3izk6siqldp9q8qlrznk14br3jdyhnr2gbdx9";
  };

  buildInputs = [ unzip cmake ];

  outputs = [ "out" "doc" ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    set -x
    cmake CMakeLists.txt -DCMAKE_INSTALL_PREFIX:PATH=$out
  '';

  installPhase = ''
    mkdir -p $out/lib/pkgconfig
    cp glm.pc $out/lib/pkgconfig

    mkdir -p "$out/include"
    cp -r glm "$out/include"

    mkdir -p "$doc/share/doc/glm"
    cp -r doc/* "$doc/share/doc/glm"
  '';

  meta = with stdenv.lib; {
    description = "OpenGL Mathematics library for C++";
    longDescription = ''
      OpenGL Mathematics (GLM) is a header only C++ mathematics library for
      graphics software based on the OpenGL Shading Language (GLSL)
      specification and released under the MIT license.
    '';
    homepage = http://glm.g-truc.net/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}

