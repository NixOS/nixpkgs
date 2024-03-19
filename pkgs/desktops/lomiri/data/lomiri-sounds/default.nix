{ stdenvNoCC
, lib
, fetchFromGitLab
, gitUpdater
, testers
, cmake
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-sounds";
  version = "22.02";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-sounds";
    rev = finalAttrs.version;
    hash = "sha256-t9JYxrJ5ICslxidHmbD1wa6n7XZMf2a+PgMLcwgsDvU=";
  };

  postPatch = ''
    # Doesn't need a compiler, only installs data
    substituteInPlace CMakeLists.txt \
      --replace 'project (lomiri-sounds)' 'project (lomiri-sounds LANGUAGES NONE)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Notification and ringtone sound effects for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-sounds";
    license = with licenses; [ cc-by-30 cc0 cc-by-sa-30 cc-by-40 ];
    maintainers = teams.lomiri.members;
    platforms = platforms.all;
    pkgConfigModules = [
      "lomiri-sounds"
    ];
  };
})
