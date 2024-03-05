{ gsmakeDerivation, fetchzip, base }:

gsmakeDerivation rec {
  version = "0.30.0";
  pname = "gnustep-gui";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/${pname}-${version}.tar.gz";
    sha256 = "sha256-24hL4TeIY6izlhQUcxKI0nXITysAPfRrncRqsDm2zNk=";
  };
  buildInputs = [ base ];
  patches = [
    ./fixup-all.patch
  ];
  meta = {
    description = "A GUI class library of GNUstep";
    changelog = "https://github.com/gnustep/libs-gui/releases/tag/gui-${builtins.replaceStrings [ "." ] [ "_" ] version}";
  };
}
