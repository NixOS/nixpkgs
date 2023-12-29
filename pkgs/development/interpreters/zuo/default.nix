{ lib, stdenv, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "unstable-2023-11-10";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "9e2aa26b0574b4ac53c838f6b59fd78f952c3923";
    hash = "sha256-wF+jj4+4uFofW9KhVqRF7EoWViRny2KuSfX/l6UN+yY=";
  };

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A Tiny Racket for Scripting";
    homepage = "https://github.com/racket/zuo";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
