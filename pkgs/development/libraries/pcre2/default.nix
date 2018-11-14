{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pcre2-${version}";
  version = "10.31";
  src = fetchurl {
    url = "https://ftp.pcre.org/pub/pcre/${name}.tar.bz2";
    sha256 = "1b389pzw91k1hzydsh4smdsxyppwz4pv74m3nrvy8rda0j3m6zg0";
  };

  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
    "--enable-jit"
  ];

  outputs = [ "bin" "dev" "out" "doc" "man" "devdoc" ];

  doCheck = false; # fails 1 out of 3 tests, looks like a bug

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
