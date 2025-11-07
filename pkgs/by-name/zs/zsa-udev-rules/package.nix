{
  lib,
  stdenv,
  fetchFromGitHub,
  udevCheckHook,
}:

stdenv.mkDerivation {
  pname = "zsa-udev-rules";
  version = "unstable-2023-11-30";

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally";
    rev = "a6648f6b543b703e3902faf5c08e997e0d58c909";
    hash = "sha256-j9n3VoX+UngX12DF28rtNh+oy80Th1BINPQqk053lvE=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  # Only copies udevs rules
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp dist/linux64/50-oryx.rules $out/lib/udev/rules.d/
    cp dist/linux64/50-wally.rules $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    description = "udev rules for ZSA devices";
    license = licenses.mit;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
    homepage = "https://github.com/zsa/wally/wiki/Linux-install#2-create-a-udev-rule-file";
  };
}
