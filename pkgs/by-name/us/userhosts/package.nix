{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "userhosts";
  version = "1.0.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "figiel";
    repo = "hosts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qpdwita1QDFGry5mNgg8pmbkVcjTzbEab742oEx6NYc=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Libc wrapper providing per-user hosts file";
    homepage = "https://github.com/figiel/hosts";
    maintainers = [ lib.maintainers.bobvanderlinden ];
    license = lib.licenses.cc0;
    platforms = lib.platforms.linux;
  };
})
