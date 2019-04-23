{ stdenv, fetchurl, gmp
, withEmacsSupport ? true
, withContrib ? true }:

let
  versionPkg = "0.3.13" ;

  contrib = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-contrib-${versionPkg}.tgz";
    sha256 = "5f64172b2df08c8563b01febc32b582b2d7b59c0c514bd2beb727e69bb8e24ee";
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
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-gmp-${version}.tgz";
    sha256 = "0056ff5bfa55c9b9831dce004e7b1b9e7a98d56a9d8ae49d827f9fd0ef823c23";
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
