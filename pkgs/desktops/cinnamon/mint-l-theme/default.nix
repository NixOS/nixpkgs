{ stdenvNoCC
, lib
, fetchFromGitHub
, python3
, sassc
, sass
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-l-theme";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-x+elC1NWcd+x8dNewwKPZBdkxSzEbo7jsG8B9DcWdoA=";
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
