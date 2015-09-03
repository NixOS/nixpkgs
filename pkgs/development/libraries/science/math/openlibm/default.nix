{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "openlibm-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "openlibm";
    rev = "v${version}";
    sha256 = "1s6mb00khjwqxzpxycr82nvfaicp9zcdjq6srx1dz1zdn4a349sh";
  };

  makeFlags = [ "prefix=" "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "An effort to have a high quality, portable, standalone C mathematical library";
    homepage = "http://openlibm.org/";
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
    license = with licenses; [ mit bsd2 isc ];
  };
}
