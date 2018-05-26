{ stdenv, fetchurl, libGLU_combined, glew, freetype, fontconfig, fribidi, libX11 }:
stdenv.mkDerivation rec {
  pname = "quesoglc";
  version = "0.7.2";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "0cf9ljdzii5d4i2m23gdmf3kn521ljcldzq69lsdywjid3pg5zjl";
  };
  buildInputs = [ libGLU_combined glew freetype fontconfig fribidi libX11 ];
  # FIXME: Configure fails to use system glew.
  meta = with stdenv.lib; {
    description = "A free implementation of the OpenGL Character Renderer";
    longDescription = ''
      QuesoGLC is a free (as in free speech) implementation of the OpenGL
      Character Renderer (GLC). QuesoGLC is based on the FreeType library,
      provides Unicode support and is designed to be easily ported to any
      platform that supports both FreeType and the OpenGL API.
    '';
    homepage = http://quesoglc.sourceforge.net/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
}
