{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libGDSII";
  version = "0.21";

  src = fetchFromGitHub {
    owner = "HomerReid";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EXEt7l69etcBdDdEDlD1ODOdhTBZCVjgY1jhRUDd/W0=";
  };

  # File is missing in the repo but automake requires it
  postPatch = ''
    touch ChangeLog
  '';

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Library and command-line utility for reading GDSII geometry files";
    mainProgram = "GDSIIConvert";
    homepage = "https://github.com/HomerReid/libGDSII";
    license = [ licenses.gpl2Only ];
    maintainers = with maintainers; [ sheepforce markuskowa ];
    platforms = platforms.linux;
  };
}
