{
  buildPecl,
  lib,
  fetchFromGitHub,
  php,
  zlib,
  pkg-config,
}:

buildPecl rec {
  pname = "memcache";
  version = "8.2";

  src = fetchFromGitHub {
    owner = "websupport-sk";
    repo = "pecl-memcache";
    rev = version;
    hash = "sha256-77GvQ59XUpIZmdYZP6IhtjdkYwXKuNBSG+LBScz2BtI=";
  };

  internalDeps = [ php.extensions.session ];

  configureFlags = [ "--with-zlib-dir=${zlib.dev}" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib ];

  meta = with lib; {
    description = "PHP extension for interfacing with memcached";
    license = licenses.php301;
    homepage = "https://github.com/websupport-sk/pecl-memcache";
    maintainers = [ maintainers.krzaczek ];
    teams = [ teams.php ];
  };
}
