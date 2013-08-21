{ stdenv, fetchurl, nasm, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "xvidcore-1.3.2";
  
  src = fetchurl {
    url = "http://downloads.xvid.org/downloads/${name}.tar.bz2";
    sha256 = "1x0b2rq6fv99ramifhkakycd0prjc93lbzrffbjgjwg7w4s17hfn";
  };

  preConfigure = ''
    cd build/generic
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace "-no-cpp-precomp" ""
  '';

  configureFlags = stdenv.lib.optionals stdenv.isDarwin
    [ "--enable-macosx_module" "--disable-assembly" ];

  buildInputs = [ nasm ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ autoconf automake libtool ];

  # don't delete the '.a' files on darwin -- they're needed to compile ffmpeg
  # (and perhaps other things)
  postInstall = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    rm $out/lib/*.a
  '' + ''
    cd $out/lib
    ln -s *.so.4.* libxvidcore.so
    if [ ! -e libxvidcore.so.4 ]; then
        ln -s *.so.4.* libxvidcore.so.4
    fi
  '';
  
  meta = with stdenv.lib; {
    description = "MPEG-4 video codec for PC";
    homepage    = http://www.xvid.org/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
  };
}

