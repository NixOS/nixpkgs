{ lib
, stdenv
, fetchurl
, autoreconfHook
, libmd
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "libbsd";
  version = "0.11.7";

  src = fetchurl {
    url = "https://libbsd.freedesktop.org/releases/${pname}-${version}.tar.xz";
    hash = "sha256-m6oYYFnrvyXAYwjp+ZH9ox9xg8DySTGCbYOqar2KAmE=";
  };

  outputs = [ "out" "dev" "man" ];

  # darwin changes configure.ac which means we need to regenerate
  # the configure scripts
  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libmd ];

  patches = [ ./darwin.patch ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://gitlab.freedesktop.org/libbsd/libbsd.git";
  };

  meta = with lib; {
    description = "Common functions found on BSD systems";
    homepage = "https://libbsd.freedesktop.org/";
    license = with licenses; [ beerware bsd2 bsd3 bsdOriginal isc mit ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
