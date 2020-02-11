{ stdenv, lib, fetchurl }:

let common = import ../gettext/common.nix { inherit fetchurl; };
in stdenv.mkDerivation rec {
  pname = "libtextstyle";
  inherit (common) version src;

  sourceRoot = "${common.pname}-${common.version}/${pname}/";

  outputs = [ "out" "doc" "info" ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Console/terminal emulator text styling library";

    longDescription = ''
      GNU libtextstyle provides an easy way to add styling to programs
      that produce output to a console or terminal emulator window
    '';

    homepage = "https://www.gnu.org/software/gettext/";

    maintainers = with maintainers; [ lsix ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
