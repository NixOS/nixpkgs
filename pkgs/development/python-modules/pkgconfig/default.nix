{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  pkg-config,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pkgconfig";
  version = "1.6.0";
  pyproject = true;

  inherit (pkg-config)
    setupHooks
    wrapperName
    suffixSalt
    targetPrefix
    baseBinName
    ;

  src = fetchFromGitHub {
    owner = "matze";
    repo = "pkgconfig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Glla/tg83Vd2VWvUnCPrcncS73vMhqaGpo+AviR8jnY=";
  };

  postPatch = ''
    substituteInPlace src/pkgconfig/pkgconfig.py \
      --replace "pkg_config_exe = os.environ.get('PKG_CONFIG', None) or 'pkg-config'" "pkg_config_exe = '${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config'"

    # those pc files are missing and pkg-config validates that they exist
    substituteInPlace tests/data/fake-openssl.pc \
      --replace "Requires: libssl libcrypto" ""
  '';

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    setuptools
  ];

  pythonImportsCheck = [ "pkgconfig" ];

  meta = {
    description = "Interface Python with pkg-config";
    homepage = "https://github.com/matze/pkgconfig";
    changelog = "https://github.com/matze/pkgconfig/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
