{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "full-border.yazi";
  version = "25.2.26-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "92f78dc6d0a42569fd0e9df8f70670648b8afb78";
    hash = "sha256-mqo71VLZsHmgTybxgqKNo9F2QeMuCSvZ89uen1VbWb4=";
  };

  # NOTE: License is a relative symbolic link
  # We remove the link and copy the true license
  installPhase = ''
    runHook preInstall

    cp -r full-border.yazi $out
    rm $out/LICENSE
    cp LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "Add a full border to Yazi to make it look fancier";
    homepage = "https://yazi-rs.github.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
