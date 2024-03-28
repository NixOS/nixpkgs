{ lib
, stdenvNoCC
, vlc
}:

stdenvNoCC.mkDerivation {
  pname = "vlc-test-001-version";
  inherit (vlc) version;

  nativeBuildInputs = [ vlc ];

  dontInstall = true;

  buildCommand = ''
    if [[ $(vlc --version 2>/dev/null | grep -c -F "VLC version ${vlc.version}") == "1" ]];
    then touch $out;
    else echo "version test failed"; exit 1
    fi
  '';

  meta.timeout = 10;
}
