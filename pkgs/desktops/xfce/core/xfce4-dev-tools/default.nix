{ lib
, stdenv
, mkXfceDerivation
, autoreconfHook
, makeBinaryWrapper
, libxslt
, docbook_xsl
, autoconf
, automake
, glib
, gtk-doc
, intltool
, libtool
, m4
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-dev-tools";
  version = "4.16.0";

  sha256 = "sha256-5r9dJfCgXosXoOAtNg1kaPWgFEAmyw/pWTtdG+K1h3A=";

  nativeBuildInputs = [
    autoreconfHook
    makeBinaryWrapper
    libxslt
    docbook_xsl
  ];

  buildInputs = [ glib ];

  # ../xdt-csource/xdt-csource: cannot execute binary file: Exec format error
  postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace Makefile.am \
    --replace 'xdt-csource \' "xdt-csource" \
     --replace "  tests" ""
  '';

  postInstall = ''
    for b in $out/bin/*; do
      wrapProgram $b --suffix PATH : ${lib.makeBinPath [ autoconf automake intltool libtool gtk-doc glib m4 ]}
    done
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Autoconf macros and scripts to augment app build systems";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
