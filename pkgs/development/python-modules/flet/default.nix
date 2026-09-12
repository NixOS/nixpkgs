{
  lib,
  buildPythonPackage,
  flet-client-flutter,
  writeText,
  pyprojectVersionPatchHook,

  # build-system
  setuptools,

  # dependencies
  httpx,
  msgpack,
  oauthlib,
  repath,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

let
  # Appended to upstream pip.py so the last definition of install_flet_package wins.
  disableInstallFletPackage = writeText "flet-disable-pip.py" ''
    def install_flet_package(name: str):
        import warnings

        warnings.warn(
            f'install_flet_package({name!r}) is disabled in the nixpkgs build; '
            f'install python3Packages."{name}" instead',
            stacklevel=2,
        )
  '';
in
buildPythonPackage (finalAttrs: {
  pname = "flet";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/sdk/python/packages/flet";

  postPatch = ''
    # Flutter SDK version used by packaging; set by CI on releases.
    substituteInPlace src/flet/version.py \
      --replace-fail 'flutter_version = ""' 'flutter_version = "3.41.7"'

    # Do not attempt pip/uv installs of companion packages under Nix.
    cat ${disableInstallFletPackage} >> src/flet/utils/pip.py
  '';

  # pyproject.toml is version = "0.1.0"; hook rewrites it to match the derivation.
  # Runtime flet.version falls back to git / "0.1.0" unless CI-style version.py pins exist.
  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    httpx
    msgpack
    oauthlib
    repath
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Unit tests only; integration_tests need the full monorepo + examples tree.
  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "flet" ];

  meta = {
    description = "Framework that enables you to easily build realtime web, mobile, and desktop apps in Python";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
    ];
    mainProgram = "flet";
  };
})
