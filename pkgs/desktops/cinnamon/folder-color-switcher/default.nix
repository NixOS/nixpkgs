{ stdenvNoCC
, lib
, fetchFromGitHub
, gettext
}:

stdenvNoCC.mkDerivation rec {
  pname = "folder-color-switcher";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # They don't really do tags, this is just a named commit.
    rev = "5e0b768b3a5bf88a828a2489b9428997b797c1ed";
    sha256 = "sha256-DU75LM5v2/E/ZmqQgyiPsOOEUw9QQ/NXNtGDFzzYvyY=";
  };

  nativeBuildInputs = [
    gettext
  ];

  postPatch = ''
    substituteInPlace usr/share/nemo-python/extensions/nemo-folder-color-switcher.py \
      --replace "/usr/share" "$out/share"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/folder-color-switcher";
    description = "Change folder colors for Nemo and Caja";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
