{ stdenv
, lib
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  pname = "flat-remix-gtk";
  version = "20220412";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = pname;
    rev = version;
    sha256 = "sha256-LIGYPsOoPN3KIe0XrjCIf7yV3p3Gfzx8zci57+HzW18=";
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
