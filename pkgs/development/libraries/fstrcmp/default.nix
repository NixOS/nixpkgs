{ stdenv, fetchzip, libtool, ghostscript, groff }:

stdenv.mkDerivation rec {
  pname = "fstrcmp";
  version = "0.7";

  src = fetchzip {
    url = "https://sourceforge.net/projects/fstrcmp/files/fstrcmp/${version}/fstrcmp-${version}.D001.tar.gz";
    sha256 = "0yg3y3k0wz50gmhgigfi2dx725w1gc8snb95ih7vpcnj6kabgz9a";
  };

  outputs = [ "out" "dev" "doc" "man" "devman" ];

  nativeBuildInputs = [ libtool ghostscript groff ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Make fuzzy comparisons of strings and byte arrays";
    longDescription = ''
      The fstrcmp project provides a library that is used to make fuzzy
      comparisons of strings and byte arrays, including multi-byte character
      strings.
    '';
    homepage = http://fstrcmp.sourceforge.net/;
    downloadPage = https://sourceforge.net/projects/fstrcmp/;
    license = licenses.gpl3;
    maintainers = [ maintainers.sephalon ];
    platforms = platforms.unix;
  };
}
