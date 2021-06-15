{ lib, stdenv, fetchurl, unzip, txt2tags }:

stdenv.mkDerivation rec {
  rev = "148";
  version = "hg-2012-12-02";
  pname = "libixp";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/libixp/source-archive.zip";
    sha256 = "0kcdvdcrkw6q39v563ncis6d7ini64xbgn5fd3b4aa95fp9sj3is";
  };

  configurePhase = ''
   sed -i -e "s|^PREFIX.*=.*$|PREFIX = $out|" config.mk
  '';

  nativeBuildInputs = [ unzip ];
  buildInputs = [ txt2tags ];

  meta = {
    homepage = "http://repo.cat-v.org/libixp/"; # see also https://libs.suckless.org/deprecated/libixp
    description = "Portable, simple C-language 9P client and server libary";
    maintainers = with lib.maintainers; [ kovirobi ];
    license = lib.licenses.mit;
    inherit version;
    platforms = with lib.platforms; unix;
  };
}
