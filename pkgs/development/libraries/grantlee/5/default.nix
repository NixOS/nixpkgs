{
  mkDerivation,
  lib,
  fetchFromGitHub,
  qtbase,
  qtscript,
  cmake,
}:

mkDerivation rec {
  pname = "grantlee";
  version = "5.3.1";
  grantleePluginPrefix = "lib/grantlee/${lib.versions.majorMinor version}";

  src = fetchFromGitHub {
    owner = "steveire";
    repo = "grantlee";
    rev = "v${version}";
    sha256 = "sha256-enP7b6A7Ndew2LJH569fN3IgPu2/KL5rCmU/jmKb9sY=";
  };

  buildInputs = [
    qtbase
    qtscript
  ];
  nativeBuildInputs = [ cmake ];

  patches = [
    ./grantlee-nix-profiles.patch
    ./grantlee-no-canonicalize-filepath.patch
  ];

  outputs = [
    "out"
    "dev"
  ];
  postFixup =
    # Disabuse CMake of the notion that libraries are in $dev
    ''
      for way in release debug; do
          cmake="$dev/lib/cmake/Grantlee5/GrantleeTargets-$way.cmake"
          if [ -f "$cmake" ]; then
              sed -i "$cmake" -e "s|\''${_IMPORT_PREFIX}|$out|"
          fi
      done
    '';

  setupHook = ./setup-hook.sh;

  doCheck = false; # fails all the tests (ctest)

  meta = with lib; {
    description = "Qt5 port of Django template system";
    longDescription = ''
      Grantlee is a plugin based String Template system written using the Qt
      framework. The goals of the project are to make it easier for application
      developers to separate the structure of documents from the data they
      contain, opening the door for theming.

      The syntax is intended to follow the syntax of the Django template system,
      and the design of Django is reused in Grantlee.'';

    homepage = "https://github.com/steveire/grantlee";
    maintainers = [ maintainers.ttuegel ];
    license = licenses.lgpl21;
    inherit (qtbase.meta) platforms;
  };
}
