{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "kona";
  version = "3.21";
  src = fetchurl {
    url = "https://github.com/kevinlawler/kona/archive/Win.${version}-64.tar.gz";
    sha256 = "0c1yf3idqkfq593xgqb25r2ykmfmp83zzh3q7kb8095a069gvri3";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  preInstall = ''mkdir -p "$out/bin"'';

  meta = with stdenv.lib; {
    description = "An interpreter of K, APL-like programming language";
    homepage = https://github.com/kevinlawler/kona/;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    license = licenses.isc;
  };
}
