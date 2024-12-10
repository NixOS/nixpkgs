{
  lib,
  fetchgit,
  stdenvNoCC,
}:

let
  make-nv-codec-headers = (import ./make-nv-codec-headers.nix) {
    inherit lib fetchgit stdenvNoCC;
  };
in
{
  nv-codec-headers-8 = make-nv-codec-headers {
    version = "8.2.15.2";
    hash = "sha256-TKYT8vXqnUpq+M0grDeOR37n/ffqSWDYTrXIbl++BG4=";
  };
  nv-codec-headers-9 = make-nv-codec-headers {
    version = "9.1.23.1";
    hash = "sha256-kF5tv8Nh6I9x3hvSAdKLakeBVEcIiXFY6o6bD+tY2/U=";
  };
  nv-codec-headers-10 = make-nv-codec-headers {
    version = "10.0.26.2";
    hash = "sha256-BfW+fmPp8U22+HK0ZZY6fKUjqigWvOBi6DmW7SSnslg=";
  };
  nv-codec-headers-11 = make-nv-codec-headers {
    version = "11.1.5.2";
    hash = "sha256-KzaqwpzISHB7tSTruynEOJmSlJnAFK2h7/cRI/zkNPk=";
  };
  nv-codec-headers-12 = make-nv-codec-headers {
    version = "12.1.14.0";
    hash = "sha256-WJYuFmMGSW+B32LwE7oXv/IeTln6TNEeXSkquHh85Go=";
  };
}
