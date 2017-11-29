{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "pcre2-${version}";
  version = "10.23";
  src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${name}.tar.bz2";
    sha256 = "0vn5g0mkkp99mmzpissa06hpyj6pk9s4mlwbjqrjvw3ihy8rpiyz";
  };

  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
    "--enable-jit"
  ];

  patches = [
    (fetchpatch {
      name = "CVE-2017-7186-part1.patch";
      url = "https://vcs.pcre.org/pcre2/code/trunk/src/pcre2_ucd.c?view=patch&r1=316&r2=670&sortby=date";
      sha256 = "10yzglvbn7h06hg7zffr5zh378i5jihvx7d5gggkynws79vgwvfr";
      stripLen = 2;
      addPrefixes = true;
    })
    (fetchpatch {
      name = "CVE-2017-7186-part2.patch";
      url = "https://vcs.pcre.org/pcre2/code/trunk/src/pcre2_internal.h?view=patch&r1=600&r2=670&sortby=date";
      sha256 = "1bggk7vd5hg0bjg96lj4h1lacmr6grq68dm6iz1n7vg3zf7virjn";
      stripLen = 2;
      addPrefixes = true;
    })
    (fetchpatch {
      name = "CVE-2017-8786.patch";
      url = "https://vcs.pcre.org/pcre2/code/trunk/src/pcre2test.c?r1=692&r2=697&view=patch";
      sha256 = "1c629nzrk4il2rfclwyc1a373q58m4q9ys9wr91zhl4skfk7x19b";
      stripLen = 2;
      addPrefixes = true;
    })
  ];

  outputs = [ "bin" "dev" "out" "doc" "man" "devdoc" ];

  postFixup = ''
    moveToOutput bin/pcre2-config "$dev"
  '';

  meta = with stdenv.lib; {
    description = "Perl Compatible Regular Expressions";
    homepage = http://www.pcre.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.all;
  };
}
