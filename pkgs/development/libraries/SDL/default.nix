{ stdenv, fetchurl, x11, libXrandr, openglSupport ? false, mesa ? null
, alsaSupport ? true, alsaLib ? null
}:

assert openglSupport -> mesa != null;
assert alsaSupport -> alsaLib != null;

stdenv.mkDerivation {
  name = "SDL-1.2.13";
  
  src = fetchurl {
    url = http://www.libsdl.org/release/SDL-1.2.13.tar.gz;
    sha256 = "0cp155296d6fy3w31jj481jxl9b43fkm01klyibnna8gsvqrvycl";
  };
  
  propagatedBuildInputs = [x11 libXrandr];
  
  buildInputs =
    stdenv.lib.optional openglSupport mesa ++
    stdenv.lib.optional alsaSupport alsaLib;
    
  configureFlags = ''
    --disable-x11-shared --disable-alsa-shared --enable-rpath
    ${if alsaSupport then "--with-alsa-prefix=${alsaLib}/lib" else ""}
  '';

  passthru = {inherit openglSupport;};

  meta = {
    description = "A cross-platform multimedia library";
    homepage = http://www.libsdl.org/;
  };
}
