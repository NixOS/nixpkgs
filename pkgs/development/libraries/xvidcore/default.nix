{stdenv, fetchurl, nasm}:

stdenv.mkDerivation rec {
  name = "xvidcore-1.3.2";
  
  src = fetchurl {
    url = "http://downloads.xvid.org/downloads/${name}.tar.bz2";
    sha256 = "1x0b2rq6fv99ramifhkakycd0prjc93lbzrffbjgjwg7w4s17hfn";
  };

  preConfigure = "cd build/generic";

  buildInputs = [ nasm ];

  postInstall =
    ''
      rm $out/lib/*.a
      (cd $out/lib && ln -s *.so.* libxvidcore.so)
    '';
  
  meta = {
    description = "MPEG-4 video codec for PC";
    homepage = http://www.xvid.org/;
    license = "GPLv2+";
  };
}

