{ lib, stdenv, pkgs }:
let
  version = "2.2.1";
in
(import ./google-clasp.nix {
  inherit pkgs;
  inherit (stdenv.hostPlatform) system;
})."@google/clasp-${version}".override {
  preRebuild = ''
    patch -p1 <<<"${builtins.readFile ./dotf.patch}"
  '';
  meta = {
    description = "Command Line tool for Google Apps Script Projects";
    homepage = "https://developers.google.com/apps-script/guides/clasp";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.michojel ];
    priority = 100;
  };
}
