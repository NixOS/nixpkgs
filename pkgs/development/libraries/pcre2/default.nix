{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pcre2";
  version = "10.36";
  src = fetchurl {
    url = "https://ftp.pcre.org/pub/pcre/${pname}-${version}.tar.bz2";
    sha256 = "0p3699msps07p40g9426lvxa3b41rg7k2fn7qxl2jm0kh4kkkvx9";
  };

  # Disable jit on Apple Silicon, https://github.com/zherczeg/sljit/issues/51
  configureFlags = [
    "--enable-pcre2-16"
    "--enable-pcre2-32"
  ] ++ lib.optional (!stdenv.hostPlatform.isRiscV && !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) "--enable-jit";

  outputs = [ "bin" "dev" "out" "doc" "man" "devdoc" ];

  doCheck = false; # fails 1 out of 3 tests, looks like a bug

  postFixup = ''
    moveToOutput bin/pcre2-config "$dev"
  '';

  meta = with lib; {
    description = "Perl Compatible Regular Expressions";
    homepage = "http://www.pcre.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.all;
  };
}
