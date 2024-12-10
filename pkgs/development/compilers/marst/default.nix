{
  lib,
  stdenv,
  fetchurl,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "marst";
  version = "2.7";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-Pue50cvjzZ+19iJxfae7VQbxpto7MPgS4jhLh7zk2lA=";
  };

  nativeBuildInputs = [
    texinfo
  ];

  postBuild = ''
    makeinfo doc/marst.texi -o doc/marst.info
  '';

  postInstall = ''
    install -m644 doc/marst.info -Dt $out/share/info/
    install -m644 doc/marst.pdf -Dt $out/share/doc/${pname}/
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/marst/";
    description = "An Algol-60-to-C translator";
    longDescription = ''
      MARST is an Algol-to-C translator. It automatically translates programs
      written on the algorithmic language Algol 60 to the C programming
      language.

      The MARST package includes three main components:

      - the translator, MARST, that translates Algol 60 programs to the C
        programming language.

      - the library, ALGLIB, that contains precompiled standard Algol 60
        procedures and other necessary library routines. This library is to be
        used at linking stage. (In the distribution the name libalgol.a is used
        for this library.)

      - the converter, MACVT, that allows to convert existing Algol 60 programs
        from some other representations to MARST representation.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
