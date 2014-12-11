{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "glm-0.9.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/ogl-math/${name}/${name}.zip";
    sha256 = "0v14xssysy3q1h2mga6rqlz722mwbis4rrx76zmvhjqh17qh4l62";
  };

  buildInputs = [ unzip ];

  outputs = [ "out" "doc" ];

  installPhase = ''
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
