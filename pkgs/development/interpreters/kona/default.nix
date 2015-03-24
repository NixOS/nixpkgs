{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "kona-${version}";
  src = fetchgit {
    url = "https://github.com/kevinlawler/kona.git";
    rev = "81e95b395144f4b02fe8782ad87c1f218b511c43";
    sha256 = "1jzxz5pg6p1y6nq3wyjyzxh0j72pzjrkm0mn1rs2mrm3zja9q658";
  };
  version = "git-${src.rev}";

  makeFlags = "PREFIX=$(out)";
  preInstall = ''mkdir -p "$out/bin"'';

  meta = with stdenv.lib; {
    description = "An interpreter of K, APL-like programming language";
    homepage = https://github.com/kevinlawler/kona/;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    license = licenses.isc;
  };
}
