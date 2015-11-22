{ stdenv, fetchFromGitHub, autoreconfHook, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  name = "librsync-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "0rc2pksdd0mhdvk8y1yix71rf19wdx1lb2ryrkhi7vcy240rvgvc";
  };

  buildInputs = [ autoreconfHook perl zlib bzip2 popt ];

  configureFlags = if stdenv.isCygwin then "--enable-static" else "--enable-shared";

  CFLAGS = "-std=gnu89";

  crossAttrs = {
    dontStrip = true;
  };

  meta = with stdenv.lib; {
    homepage = http://librsync.sourceforge.net/;
    license = licenses.lgpl2Plus;
    description = "Implementation of the rsync remote-delta algorithm";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
