{
  asciidoctor,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "tapview";
  version = "1.1";

  nativeBuildInputs = [ asciidoctor ];

  src = fetchFromGitLab {
    owner = "esr";
    repo = pname;
    rev = version;
    hash = "sha256-inrxICNglZU/tup+YnHaDiVss32K2OXht/7f8lOZI4g=";
  };

  # Remove unnecessary `echo` checks: `/bin/echo` fails, and `echo -n` works as expected.
  patches = [ ./dont_check_echo.patch ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Minimalist pure consumer for TAP (Test Anything Protocol)";
    mainProgram = "tapview";
    homepage = "https://gitlab.com/esr/tapview";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pamplemousse ];
  };
}
