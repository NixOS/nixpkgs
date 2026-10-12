{
  lib,
  buildPecl,
  fetchFromGitHub,
  pkg-config,
  libthai,
}:

buildPecl rec {
  pname = "wikidiff2";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "mediawiki-php-wikidiff2";
    tag = version;
    hash = "sha256-rBVwqeNioLXOd6Tr2I/Jw8phL7nYsWseYwk+lZDH2tw=";
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
