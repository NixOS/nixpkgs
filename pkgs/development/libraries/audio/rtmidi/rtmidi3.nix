{ stdenv, fetchFromGitHub, rtmidi2 }:

rtmidi2.overrideAttrs (oldAttrs: rec {
  name    = "rtmidi-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner  = "thestk";
    repo   = "rtmidi";
    rev    = "v${version}";
    sha256 = "1z4sj85vvnmvg4pjjs963ghi69srb63jp5xpck46dcb9wgypdviy";
  };

})