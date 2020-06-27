{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "stix-two";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "stipub";
    repo = "stixfonts";
    rev = "v${version}";
    sha256 = "1w8dgsf798njhgch92dyvldiwkhcavkrrxfgy9yfxb4zbdgwrarg";
  };

  dontBuild = false;
  buildPhase = "rm -rf archive";

  meta = with lib; {
    homepage = "http://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ rycee ];
  };
}
