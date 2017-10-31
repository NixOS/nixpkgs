{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "sparsehash-2.0.3";

  src = fetchFromGitHub {
    owner = "sparsehash";
    repo = "sparsehash";
    rev = name;
    sha256 = "0m3f0cnpnpf6aak52wn8xbrrdw8p0yhq8csgc8nlvf9zp8c402na";
  };

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/sparsehash/;
    description = "An extremely memory-efficient hash_map implementation";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
  };
}
