{
  lib,
  buildPecl,
  fetchFromGitHub,
  pkg-config,
  libthai,
}:

buildPecl rec {
  pname = "wikidiff2";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "mediawiki-php-wikidiff2";
    tag = version;
    hash = "sha256-UTOfLXv2QWdjThxfrPQDLB8Mqo4js6LzOKXePivdp9k=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libthai ];

  meta = {
    description = "PHP extension which formats changes between two input texts, producing HTML or JSON";
    license = lib.licenses.gpl2;
    homepage = "https://www.mediawiki.org/wiki/Wikidiff2";
    maintainers = with lib.maintainers; [ georgyo ];
  };
}
