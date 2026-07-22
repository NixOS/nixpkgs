{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "userhosts";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "figiel";
    repo = "hosts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9uF0fYl4Zz/Ia2UKx7CBi8ZU8jfWoBfy2QSgTSwXo5A";
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
