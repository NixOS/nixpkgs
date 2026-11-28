{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  libmediainfo,
  pdm-backend,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymediainfo";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbraz";
    repo = "pymediainfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DWw/UUXP8DsaulNX1SrKUEptMR52q1QJRf5xlSP2heg=";
  };

  postPatch = ''
    substituteInPlace src/pymediainfo/__init__.py \
      --replace-fail "libmediainfo.0.dylib" \
                "${libmediainfo}/lib/libmediainfo.0${stdenv.hostPlatform.extensions.sharedLibrary}" \
      --replace-fail "libmediainfo.dylib" \
                "${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}" \
      --replace-fail "libmediainfo.so.0" \
                "${libmediainfo}/lib/libmediainfo${stdenv.hostPlatform.extensions.sharedLibrary}.0"
  '';

  build-system = [ pdm-backend ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Disabled upstream due to bug in MediaInfo 26.10
    # See: https://github.com/sbraz/pymediainfo/blob/master/tests/test_pymediainfo.py#L236
    # See: https://github.com/MediaArea/MediaInfoLib/pull/2744
    # TODO: Remove this once MediaInfo 26.10 is no longer used in Nixpkgs
    "test_parse_cover_data"
  ]
  ++ lib.optionals stdenv.buildPlatform.isDarwin [
    # Cannot open a socket on darwin
    "test_parse_url"
  ];

  pythonImportsCheck = [ "pymediainfo" ];

  meta = {
    description = "Python wrapper for the mediainfo library";
    homepage = "https://github.com/sbraz/pymediainfo";
    changelog = "https://github.com/sbraz/pymediainfo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philipdb ];
  };
})
