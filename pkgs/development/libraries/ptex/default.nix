{ stdenv, fetchFromGitHub, zlib, python, cmake }:

stdenv.mkDerivation rec
{
  name = "ptex-${version}";
  version = "2.1.28";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "ptex";
    rev = "v${version}";
    sha256 = "1h6gb3mpis4m6ph7h9q764w50f9jrar3jz2ja76rn5czy6wn318x";
  };

  outputs = [ "bin" "dev" "out" "lib" ];

  buildInputs = [ zlib python cmake ];

  sourceRoot = "ptex-v${version}-src";

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
