{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec
{
  name = "guix-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/guix/guix-binary-${version}.${stdenv.targetPlatform.system}.tar.xz";
    sha256 = {
      "x86_64-linux" = "sha256-xffvtIlHVF5J0tr0jQ+DLzXSqNGfZdqvYHlCWsMnwFA=";
      "i686-linux" = "sha256-QHOK7hFh8LmRFK+EnNBNqfDNwQ0ia0lqRiHov9uyG2Q=";
      "aarch64-linux" = "sha256-RE9lNs9ZWWNhI6xxjbm4UHFQLkhVVbLYAb8pNpMIEM4=";
    }."${stdenv.targetPlatform.system}";
  };
  sourceRoot = ".";

  outputs = [ "out" "store" "var" ];
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    # copy the /gnu/store content
    mkdir -p $store
    cp -r gnu $store

    # copy /var content
    mkdir -p $var
    cp -r var $var

    # link guix binaries
    mkdir -p $out/bin
    ln -s /var/guix/profiles/per-user/root/current-guix/bin/guix $out/bin/guix
    ln -s /var/guix/profiles/per-user/root/current-guix/bin/guix-daemon $out/bin/guix-daemon
  '';

  meta = {
    description = "The GNU Guix package manager";
    homepage = "https://www.gnu.org/software/guix/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ johnazoidberg mohe2015 ];
    platforms = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];
  };
}
