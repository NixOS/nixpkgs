{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "c-blosc";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "18665lwszwbb48pxgisyxxjh92sr764hv6h7jw8zzsmzdkgzrmcw";
  };

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A blocking, shuffling and loss-less compression library";
    homepage = http://www.blosc.org;
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
