{ stdenv, fetchurl, gmp
, withEmacsSupport ? true
, withContrib ? true }:

let
  versionPkg = "0.2.11" ;

  contrib = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-contrib-${versionPkg}.tgz" ;
    sha256 = "0kc4nx1904745c1rkj9yfbayidw7rks1mwq0lxmvsgghn98dxwjn" ;
  };

  postInstallContrib = stdenv.lib.optionalString withContrib
  ''
    local contribDir=$out/lib/ats2-postiats-*/ ;
    mkdir -p $contribDir ;
    tar -xzf "${contrib}" --strip-components 1 -C $contribDir ;
  '';

  postInstallEmacs = stdenv.lib.optionalString withEmacsSupport
  ''
    local siteLispDir=$out/share/emacs/site-lisp/ats2 ;
    mkdir -p $siteLispDir ;
    install -m 0644 -v ./utils/emacs/*.el $siteLispDir ;
  '';
in

stdenv.mkDerivation rec {
  name    = "ats2-${version}";
  version = versionPkg;

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-${version}.tgz";
    sha256 = "140xy129fr11bdf4bj6qya9mf0fhnv2x7ksb9j46pf2yzrsrks8g";
  };

  buildInputs = [ gmp ];

  setupHook = with stdenv.lib;
    let
      hookFiles =
        [ ./setup-hook.sh ]
        ++ optional withContrib ./setup-contrib-hook.sh;
    in
      builtins.toFile "setupHook.sh"
      (concatMapStringsSep "\n" builtins.readFile hookFiles);

  patches = [ ./installed-lib-directory-version.patch ];

  postInstall = postInstallContrib + postInstallEmacs;

  meta = with stdenv.lib; {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ttuegel ];
  };
}
