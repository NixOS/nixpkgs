{ stdenv, fetchurl, pkgconfig, efl, pcre, curl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ephoto-${version}";
  version = "1.5";
  
  src = fetchurl {
    url = "http://www.smhouston.us/stuff/${name}.tar.gz";
    sha256 = "09kraa5zz45728h2dw1ssh23b87j01bkfzf977m48y1r507sy3vb";
  };

  nativeBuildInputs = [ (pkgconfig.override { vanilla = true; }) makeWrapper ];

  buildInputs = [ efl pcre curl ];

  postInstall = ''
    wrapProgram $out/bin/ephoto --prefix LD_LIBRARY_PATH : ${curl.out}/lib
  '';

  meta = {
    description = "Image viewer and editor written using the Enlightenment Foundation Libraries";
    homepage = http://smhouston.us/ephoto/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
