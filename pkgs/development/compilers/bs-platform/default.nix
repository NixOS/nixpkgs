{ lib, stdenv, runCommand, fetchFromGitHub, ninja, nodejs, python3, ... }:
let
  build-bs-platform = import ./build-bs-platform.nix;
in
(build-bs-platform rec {
  inherit lib stdenv runCommand fetchFromGitHub ninja nodejs python3;
  version = "8.2.0";
  ocaml-version = "4.06.1";

  patches = [ ./jscomp-release-ninja.patch ];

  src = fetchFromGitHub {
    owner = "BuckleScript";
    repo = "bucklescript";
    rev = version;
    sha256 = "1hql7sxps1k17zmwyha6idq6nw20abpq770l55ry722birclmsmf";
    fetchSubmodules = true;
  };
}).overrideAttrs (attrs: {
  meta = with lib; {
    description = "A JavaScript backend for OCaml focused on smooth integration and clean generated code";
    homepage = "https://bucklescript.github.io";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ turbomack gamb ];
    platforms = platforms.all;
  };
})
