{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "jump-to-char.yazi";
  version = "25.2.26-unstable-2025-03-02";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b44c245500b34e713732a9130bf436b13b4777e9";
    hash = "sha256-nZ8yfnKvNLM5aA+mmQ3PkfM5lwSKwWnkQewcg9GwseI=";
  };

  # NOTE: License is a relative symbolic link
  # We remove the link and copy the true license
  installPhase = ''
    runHook preInstall

    cp -r jump-to-char.yazi $out
    rm $out/LICENSE
    cp LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "Switch the preview pane between hidden and shown";
    homepage = "https://yazi-rs.github.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
