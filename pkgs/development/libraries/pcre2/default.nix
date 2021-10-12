{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "pcre2";
  version = "10.37";
  src = fetchurl {
    url = "https://ftp.pcre.org/pub/pcre/${pname}-${version}.tar.bz2";
    hash = "sha256-TZWpbouAUpiTtFYr4SZI15i5V7G6Gq45YGu8KrlW0nA=";
  };

  # Disable jit on Apple Silicon, https://github.com/zherczeg/sljit/issues/51
  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
  ] ++ lib.optional (!stdenv.hostPlatform.isRiscV &&
                     !(stdenv.hostPlatform.isDarwin &&
                       stdenv.hostPlatform.isAarch64)) "--enable-jit";

  outputs = [ "bin" "dev" "out" "doc" "man" "devdoc" ];

  postFixup = ''
    moveToOutput bin/pcre2-config "$dev"
  '';

  meta = with lib; {
    homepage = "http://www.pcre.org/";
    description = "Perl Compatible Regular Expressions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.all;
  };
}
