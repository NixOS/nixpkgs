{ lib
, stdenv
, fetchFromGitHub
, configureFlags ? [ "--demo=n" ]
}:

stdenv.mkDerivation rec {
  pname = "tbox";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "tboox";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6SqMvwxKSiJO7Z33xx7cJoECu5AJ1gWF8ZsiERWx8DU=";
  };

  inherit configureFlags;

  meta = with lib; {
    homepage = "https://docs.tboox.org";
    description = "A glib-like multi-platform C library";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ candyc1oud ];
  };
}
