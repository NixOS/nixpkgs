{ kde, kdelibs, hunspell }:

kde {
  buildInputs = [ kdelibs hunspell ];

  meta = {
    description = "KDE 4 Computer-aided translation system";
    longDescription = ''
      Computer-aided translation system.
      Do not translate what had already been translated.
    '';
  };
}
