{ gsmakeDerivation, fetchzip, base }:

gsmakeDerivation rec {
  version = "0.29.0";
  pname = "gnustep-gui";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/${pname}-${version}.tar.gz";
    sha256 = "0x6n48p178r4zd8f4sqjfqd6rp49w00wr59w19lpwlmrdv7bn538";
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
