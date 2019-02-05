{ stdenv, fetchgit
, mono
, imagemagick
, version, nameVersion, rev ? null, sha256 }:

stdenv.mkDerivation rec {
  name = "cito-${version}";
  inherit version;

  src = fetchgit {
    url = "https://git.code.sf.net/p/cito/code";
    rev = if rev != null then rev else "cito-${version}";
    name = "cito-${nameVersion}";
    inherit sha256;
  };

  nativeBuildInputs = [ imagemagick ];
  buildInputs = [ mono ];

  postPatch = ''
    substituteInPlace Makefile --replace /usr/bin/mono ${mono}/bin/mono
  '';
  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "Translator from Ć to C, Java, C#, JavaScript, ActionScript, Perl and D";
    longDescription = ''
      cito automatically translates the Ć programming language to C, Java, C#,
      JavaScript, ActionScript, Perl and D. Ć is a new language, aimed at
      crafting portable programming libraries, with syntax akin to C#. The
      translated code is lightweight (no virtual machine, emulation nor large
      runtime), human-readable and fits well the target language (including
      naming conventions and documentation comments).
    '';
    homepage = http://cito.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bb010g ];
    platforms = with platforms; unix;
  };
}
