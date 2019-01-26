{ stdenv, fetchurl, gmp
, withEmacsSupport ? true
, withContrib ? true }:

let
  versionPkg = "0.3.12" ;

  contrib = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-contrib-${versionPkg}.tgz" ;
    sha256 = "6e53e3070f50600373b857a73a76196adffcabc3c0d3173eaaf9a5f50f4596f4";
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
    sha256 = "63eb02b225a11752745e8f08691140ed764288ab4ceda3710670cde24835b0d8";
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

  postInstall = postInstallContrib + postInstallEmacs;

  meta = with stdenv.lib; {
    description = "Functional programming language with dependent types";
    homepage    = "http://www.ats-lang.org";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ttuegel bbarker ];
  };
}
