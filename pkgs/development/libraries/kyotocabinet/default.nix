{ lib, stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "kyotocabinet";
  version = "1.2.80";

  src = fetchurl {
    url = "https://dbmx.net/kyotocabinet/pkg/kyotocabinet-${version}.tar.gz";
    sha256 = "sha256-TIXXNmaNgpIL/b25KsPWa32xEI8JWBp2ndkWCgLe80k=";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace kccommon.h \
      --replace-fail tr1/unordered_map unordered_map \
      --replace-fail tr1/unordered_set unordered_set \
      --replace-fail tr1::hash std::hash \
      --replace-fail tr1::unordered_map std::unordered_map \
      --replace-fail tr1::unordered_set std::unordered_set

    substituteInPlace lab/kcdict/Makefile --replace-fail stdc++ c++
    substituteInPlace configure \
        --replace-fail /usr/local/bin:/usr/local/sbin: "" \
        --replace-fail /usr/bin:/usr/sbin: "" \
        --replace-fail /bin:/sbin: "" \
        --replace-fail stdc++ c++
  '';

  buildInputs = [ zlib ];

  meta = with lib; {
    homepage = "https://dbmx.net/kyotocabinet";
    description = "Library of routines for managing a database";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
