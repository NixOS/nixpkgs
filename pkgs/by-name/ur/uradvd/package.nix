{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "uradvd";
  version = "0-unstable-2025-08-16";

  src = fetchFromGitHub {
    owner = "freifunk-gluon";
    repo = "uradvd";
    rev = "b37524dfb0292c425fd61f5bffb3101fb1979264";
    hash = "sha256-PyOAt9dTFdHHF7OlHi9BBTjCN2Hmk8BsHkD2rV94ZDM=";
  };

  installPhase = ''
    runHook preInstall

    install -D --mode=0755 uradvd -t "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Tiny IPv6 Router Advertisement Daemon";
    homepage = "https://github.com/freifunk-gluon/uradvd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "uradvd";
  };
}
