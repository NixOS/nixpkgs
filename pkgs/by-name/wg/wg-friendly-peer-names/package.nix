{
  stdenv,
  lib,
  fetchFromGitHub,
  wireguard-tools,
}:

stdenv.mkDerivation {
  pname = "wg-friendly-peer-names";
  version = "0-unstable-2021-12-10";

  src = fetchFromGitHub {
    owner = "FlyveHest";
    repo = "wg-friendly-peer-names";
    rev = "b0c3e1a95c843dc9c6432895105b839ef9b362fc";
    hash = "sha256-aGxrABmR+aQO35RYo/zI2037clnGOW0Tr16p7M1fQqc=";
  };

  installPhase = ''
    install -D wgg.sh $out/bin/wgg
  '';

  meta = with lib; {
    homepage = "https://github.com/FlyveHest/wg-friendly-peer-names";
    description = "Small shellscript that makes it possible to give peers a friendlier and more readable name in the `wg` peer list";
    license = licenses.mit;
    platforms = wireguard-tools.meta.platforms;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "wgg";
  };
}
