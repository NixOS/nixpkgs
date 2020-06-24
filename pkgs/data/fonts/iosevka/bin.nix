{ stdenv, mkFont, fetchzip }:

mkFont rec {
  pname = "iosevka-bin";
  version = "2.3.3";

  src = fetchzip {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/ttc-iosevka-${version}.zip";
    sha256 = "1drni30kjcsfz3rfflkk8nqrj0yklsx467knpwqsg69683848fld";
    stripRoot = false;
  };

  meta = with stdenv.lib; {
    homepage = "https://be5invis.github.io/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.cstrahan ];
  };
}
