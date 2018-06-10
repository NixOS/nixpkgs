{ stdenv, fetchFromGitHub, zlib, python, cmake }:

stdenv.mkDerivation rec
{
  name = "ptex-${version}";
  version = "2.1.33";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "ptex";
    rev = "v${version}";
    sha256 = "15ijjq3w7hwgm4mqah0x4jzjy3v2nnmmv28lbqzmxzcxjgh4sjkn";
  };

  outputs = [ "bin" "dev" "out" "lib" ];

  buildInputs = [ zlib python cmake ];

  enableParallelBuilding = true;

  buildPhase = ''
      mkdir -p $out

      make prefix=$out

      mkdir -p $bin/bin
      mkdir -p $dev/include
      mkdir -p $lib/lib
      '';

  installPhase = ''
    make install
    mv $out/bin $bin/
  '';

  meta = with stdenv.lib; {
    description = "Per-Face Texture Mapping for Production Rendering";
    homepage = "http://ptex.us/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
