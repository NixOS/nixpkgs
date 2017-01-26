{ stdenv, fetchurl, gmp
, withEmacsSupport ? true
, withContrib ? true }:

let
  versionPkg = "0.3.0" ;

  contrib = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-contrib-${versionPkg}.tgz" ;
    sha256 = "1s4yscisn9gsr692jmh4y5mz03012pv84cm7l5n51v83wc08fks0" ;
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
    sha256 = "1knf03r8a5sis7n8rw54flf1lxfbr3prywxb1czcdp6hsbcd1v1d";
  };

  patches = [ ./install-postiats-contrib.patch ];

  buildInputs = [ gmp ];

  setupHook = with stdenv.lib;
    let
      hookFiles =
        [ ./setup-hook.sh ]
        ++ optional withContrib ./setup-contrib-hook.sh;
    in
      builtins.toFile "setupHook.sh"
      (concatMapStringsSep "\n" builtins.readFile hookFiles);

  postInstall = postInstallContrib + postInstallEmacs;

  meta = with stdenv.lib; {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ttuegel ];
  };
}
