{ stdenv
, lib
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  pname = "flat-remix-gtk";
  version = "20211130";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = pname;
    rev = version;
    sha256 = "0n6djx346bzk558yd9nk0r6hqszcbkj0h1pv2n8n15ps2j9lyvw8";
  };

  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  meta = with lib; {
    description = "GTK application theme inspired by material design";
    homepage = "https://drasite.com/flat-remix-gtk";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.mkg20001 ];
  };
}
