{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "userhosts";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "figiel";
    repo = "hosts";
    rev = "v${version}";
    hash = "sha256-9uF0fYl4Zz/Ia2UKx7CBi8ZU8jfWoBfy2QSgTSwXo5A";
  };

  installFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Libc wrapper providing per-user hosts file";
    homepage = "https://github.com/figiel/hosts";
    maintainers = [ lib.maintainers.bobvanderlinden ];
    license = lib.licenses.cc0;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Libc wrapper providing per-user hosts file";
    homepage = "https://github.com/figiel/hosts";
    maintainers = [ maintainers.bobvanderlinden ];
    license = licenses.cc0;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
