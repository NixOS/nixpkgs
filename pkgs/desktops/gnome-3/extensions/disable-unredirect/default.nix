{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-disable-unredirect";
  version = "unstable-2021-01-17";

  src = fetchFromGitHub {
    owner = "kazysmaster";
    repo = "gnome-shell-extension-disable-unredirect";
    rev = "2ecb2f489ea3316b77d04f03a0c885f322c67e79";
    sha256 = "1rjyrg8qya0asndxr7189a9npww0rcxk02wkxrxjy7fdp5m89p7y";
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
