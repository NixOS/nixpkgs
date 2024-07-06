{
  lib,
  stdenv,
  fetchFromGitHub,
  teamspeak_client,

  version ? "26",
  hash ? "sha256-oXyOqje4x79ymkG3YoS4zb25R2+HaYiUDwpZnUErag4=",
}:

let
  pname = "ts3client-pluginsdk";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "teamspeak";
    repo = pname;
    rev = version;
    inherit hash;
  };

  outputs = [ "dev" "ts3_plugin" "out" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $dev $out
    cp -a $src/include/ $dev/include/

    # This is a test plugin built to verify that the SDK works
    install ts3_plugin.so -Dt $test_plugin/

    runHook postInstall
  '';

  meta = {
    description = "TeamSpeak 3 Client Plugin SDK and example plugin (available in the `ts3_plugin` output)";
    license = lib.licenses.unfree; # Copyright © TeamSpeak Systems GmbH. All rights reserved.
    inherit (teamspeak_client.meta) platforms; # Doesn't make sense to use anywhere else.
    maintainers = with lib.maintainers; [ atemu ];
  };
}
