{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "myrica";
  version = "2.011.20160403";

  src = fetchFromGitHub {
    owner = "tomokuni";
    repo = "Myrica";
    # commit does not exist on any branch on the target repository
    rev = "b737107723bfddd917210f979ccc32ab3eb6dc20";
    hash = "sha256-kx+adbN2DsO81KJFt+FGAPZN+1NpE9xiagKZ4KyaJV0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp product/*.TTC $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://myrica.estable.jp/";
    license = licenses.ofl;
    maintainers = with maintainers; [ mikoim ];
    platforms = platforms.all;
  };
}
