# Zenstates provides access to a variety of CPU tunables no Ryzen processors.
#
# In particular, I am adding Zenstates because I need it to disable the C6
# sleep state to stabilize wake from sleep on my Lenovo x395 system. After
# installing Zenstates, I need a before-sleep script like so:
#
# before-sleep = pkgs.writeScript "before-sleep" ''
#   #!${pkgs.bash}/bin/bash
#   ${pkgs.zenstates}/bin/zenstates --c6-disable
# '';
#
# ...
#
# systemd.services.before-sleep = {
#     description = "Jobs to run before going to sleep";
#     serviceConfig = {
#       Type = "oneshot";
#       ExecStart = "${before-sleep}";
#     };
#     wantedBy = [ "sleep.target" ];
#     before = [ "sleep.target" ];
#   };

{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
stdenv.mkDerivation {
  pname = "zenstates";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "r4m0n";
    repo = "ZenStates-Linux";
    rev = "0bc27f4740e382f2a2896dc1dabfec1d0ac96818";
    sha256 = "1h1h2n50d2cwcyw3zp4lamfvrdjy1gjghffvl3qrp6arfsfa615y";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/zenstates.py $out/bin/zenstates
    chmod +x $out/bin/zenstates
    patchShebangs --build $out/bin/zenstates
  '';

  meta = with lib; {
    description = "Linux utility for Ryzen processors and motherboards";
    mainProgram = "zenstates";
    homepage = "https://github.com/r4m0n/ZenStates-Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ savannidgerinel ];
    platforms = platforms.linux;
  };
}
