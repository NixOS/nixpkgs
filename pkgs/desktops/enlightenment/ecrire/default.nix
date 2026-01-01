{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  efl,
  directoryListingUpdater,
}:

stdenv.mkDerivation rec {
  pname = "ecrire";
  version = "0.2.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1pszk583rzclfqy3dyjh1m9pz1hnr84vqz8vw9kngcnmj23mjr6r";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    efl
  ];

  passthru.updateScript = directoryListingUpdater { };

<<<<<<< HEAD
  meta = {
    description = "EFL simple text editor";
    mainProgram = "ecrire";
    homepage = "https://www.enlightenment.org/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.enlightenment ];
=======
  meta = with lib; {
    description = "EFL simple text editor";
    mainProgram = "ecrire";
    homepage = "https://www.enlightenment.org/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    teams = [ teams.enlightenment ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
