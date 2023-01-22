{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, enableXml ? true
, enableZip ? true
, enableHash ? true
, enableRegex ? true
, enableObject ? true
, enableCharset ? true
, enableDatabase ? true
, enableCoroutine ? true
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

  configureFlags = [ "--demo=no" ] ++ lib.optional enableXml "--xml=yes"
    ++ lib.optional enableZip "--zip=yes"
    ++ lib.optional enableHash "--hash=yes"
    ++ lib.optional enableRegex "--regex=yes"
    ++ lib.optional enableObject "--object=yes"
    ++ lib.optional enableCharset "--charset=yes"
    ++ lib.optional enableDatabase "--database=yes"
    ++ lib.optional enableCoroutine "--coroutine=yes";

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A glib-like cross-platform C library";
    homepage = "https://docs.tboox.org";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ candyc1oud ];
  };
}
