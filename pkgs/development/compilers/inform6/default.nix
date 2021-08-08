{ lib, stdenv, fetchFromGitLab, perl }:

stdenv.mkDerivation rec {
  pname = "inform6";
  version = "6.34-6.12.4-1";

  src = fetchFromGitLab {
    owner = "DavidGriffith";
    repo = "inform6unix";
    rev = version;
    sha256 = "sha256-VjlTu7IIY12qLlqfuV0DyzC3z6rFdR8iXo966TrOpGs=";
  };

  buildInputs = [ perl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Interactive fiction compiler and libraries";
    longDescription = ''
      Inform 6 is a C-like programming language for writing interactive fiction
      (text adventure) games.
    '';
    homepage = "https://gitlab.com/DavidGriffith/inform6unix";
    changelog = "https://gitlab.com/DavidGriffith/inform6unix/-/raw/${version}/NEWS";
    license = licenses.artistic2;
    maintainers = with lib.maintainers; [ ddelabru ];
    platforms = platforms.all;
  };
}
