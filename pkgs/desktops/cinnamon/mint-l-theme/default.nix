{ stdenvNoCC
, lib
, fetchFromGitHub
, python3
, sassc
, sass
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-l-theme";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # They don't really do tags, this is just a named commit.
    rev = "078219f4f947245b3b7bf271c7311f67bf744bfb";
    hash = "sha256-GK1bwKeyYTXZUNnOdOnqu2C0ZwJHheRVRYL2SLwOnd0=";
  };

  nativeBuildInputs = [
    python3
    sassc
    sass
  ];

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-l-theme";
    description = "Mint-L theme for the Cinnamon desktop";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
