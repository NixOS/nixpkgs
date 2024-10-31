{ lib, stdenv, fetchurl, libGLU, libGL, glew, freetype, fontconfig, fribidi, libX11 }:
stdenv.mkDerivation rec {
  pname = "quesoglc";
  version = "0.7.2";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0cf9ljdzii5d4i2m23gdmf3kn521ljcldzq69lsdywjid3pg5zjl";
  };
  buildInputs = [ libGLU libGL glew freetype fontconfig fribidi libX11 ];
  # FIXME: Configure fails to use system glew.
  meta = with lib; {
    description = "Free implementation of the OpenGL Character Renderer";
    longDescription = ''
      QuesoGLC is a free (as in free speech) implementation of the OpenGL
      Character Renderer (GLC). QuesoGLC is based on the FreeType library,
      provides Unicode support and is designed to be easily ported to any
      platform that supports both FreeType and the OpenGL API.
    '';
    homepage = "https://quesoglc.sourceforge.net/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
}
