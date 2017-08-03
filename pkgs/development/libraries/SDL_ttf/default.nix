{ stdenv, fetchurl, fetchpatch, SDL, freetype }:

stdenv.mkDerivation rec {
  name = "SDL_ttf-${version}";
  version = "2.0.11";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_ttf/release/${name}.tar.gz";
    sha256 = "1dydxd4f5kb1288i5n5568kdk2q7f8mqjr7i7sd33nplxjaxhk3j";
  };

  patches = [
    # Bug #830: TTF_RenderGlyph_Shaded is broken
    (fetchpatch {
      url = "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=830";
      sha256 = "0cfznfzg1hs10wl349z9n8chw80i5adl3iwhq4y102g0xrjyb72d";
    })
  ];

  patchFlags = [ "-p0" ];

  buildInputs = [ SDL freetype ];

  meta = with stdenv.lib; {
    description = "SDL TrueType library";
    license = licenses.zlib;
    platforms = platforms.all;
    homepage = https://www.libsdl.org/projects/SDL_ttf/release-1.2.html;
    maintainers = with maintainers; [ abbradar ];
  };
}
