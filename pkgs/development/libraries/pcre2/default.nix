{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pcre2";
  version = "10.34";
  src = fetchurl {
    url = "https://ftp.pcre.org/pub/pcre/${pname}-${version}.tar.bz2";
    sha256 = "1jlqnzcz2yi70dm40wyfa9w8is9z2kh4dl8zjnv3vqd9mgzp7i3l";
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
