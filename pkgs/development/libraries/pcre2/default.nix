{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "pcre2";
  version = "10.39";
  src = fetchurl {
    url = "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${version}/pcre2-${version}.tar.bz2";
    hash = "sha256-DwPK9X+B2f82KsKM04nAVewr8GeNJ3NJoaS+4ArW1EA=";
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
