{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yaml-cpp";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    tag = "yaml-cpp-${finalAttrs.version}";
    hash = "sha256-+FOsPQY44h1g9tEw3O281LkiYKXdW2jnFKw+oTRkhGw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "YAML_CPP_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "YAML_CPP_BUILD_TOOLS" false)
    (lib.cmakeBool "YAML_BUILD_SHARED_LIBS" (!static))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater { rev-prefix = "yaml-cpp-"; };

  meta = {
    description = "YAML parser and emitter for C++";
    homepage = "https://github.com/jbeder/yaml-cpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
})
