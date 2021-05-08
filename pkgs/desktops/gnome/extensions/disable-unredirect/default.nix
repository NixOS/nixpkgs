{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-disable-unredirect";
  version = "unstable-2021-04-13";

  src = fetchFromGitHub {
    owner = "kazysmaster";
    repo = "gnome-shell-extension-disable-unredirect";
    rev = "2a4c0e6a7a7a5f1aad9907ee2cf43d0725e10c19";
    sha256 = "06hbyy20xz0bvzg0vs5w4092nyfpg372c86cdm1akcjm72m5sim9";
  };

  uuid = "unredirect@vaina.lt";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gnome-shell/extensions
    cp -R ${uuid} $out/share/gnome-shell/extensions/${uuid}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Disables unredirect fullscreen windows in gnome-shell to avoid tearing";
    license = licenses.gpl3Only;
    homepage = "https://github.com/kazysmaster/gnome-shell-extension-disable-unredirect";
    maintainers = with maintainers; [ eduardosm ];
  };
}
