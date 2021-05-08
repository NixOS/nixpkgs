{ stdenv
, lib
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  pname = "flat-remix-gtk";
  version = "20201129";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = pname;
    rev = version;
    hash = "sha256-lAlHRVB/P3A1qWsXQZPZ3uhgctR4FLa+ocUrsbleXJU=";
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
