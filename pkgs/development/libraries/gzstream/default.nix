{ stdenv, lib, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "gzstream";
  version = "1.5";

  src = fetchurl {
    url = "https://archive.org/download/httpswww.cs.unc.eduresearchcompgeomgzstreamgzstream.tgz/gzstream.tgz";
    sha256 = "00y19pqjsdj5zcrx4p9j56pl73vayfwnb7y2hvp423nx0cwv5b4r";
  };

  buildInputs = [ zlib ];

  # Remove precompiled object file.
  preBuild = ''
    rm gzstream.o
  '';

  doCheck = true;
  checkTarget = "test";

  # The makefile supplied doesn't provide an install target.
  installPhase = ''
    mkdir -p $out/{include,lib}
    cp gzstream.h $out/include
    cp libgzstream.a $out/lib
  '';

  meta = with lib; {
    description = "A small library for providing zlib functionality in a C++ iostream";
    homepage = "https://www.cs.unc.edu/Research/compgeom/gzstream";
    license = licenses.lgpl21Plus;
    maintainers = [ teams.deshaw.members ];
  };
}
