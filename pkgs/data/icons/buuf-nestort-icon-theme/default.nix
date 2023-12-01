{ lib, stdenvNoCC, fetchgit }:

stdenvNoCC.mkDerivation {
  pname = "buuf-netsort-icon-theme";
  version = "2023-11-17";

  src = fetchgit {
    url = "https://git.disroot.org/eudaimon/buuf-nestort.git";
    rev = "e946fc5aafdc3f9ccc056bc8b70ab2489c676812";
    hash = "sha256-phBREuCOMPLMSEUyYkgG37SDyTP95tNb/jtk93QQTvQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/
    cp -r . $out/share/icons/buuf-netsort-icon-theme

    runHook postInstall
  '';

  meta = with lib; {
    description = "A whimsical and unique icon theme adapted for many desktops";
    homepage = "https://git.disroot.org/eudaimon/buuf-nestort";
    platforms = platforms.all;
    license = licenses.cc-by-nc-sa-25;
    maintainers = with maintainers; [ sk4rd ];
  };
}
