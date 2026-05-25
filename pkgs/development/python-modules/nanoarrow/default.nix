{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  meson,
  meson-python,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  zlib,
  zstd-c,

  pytestCheckHook,
}:

let
  # Nanoarrow requires a specific post-0.6.1 flatcc commit that adds `_with_size` API variants not
  # present in the upstream 0.6.1 release.
  flatcc-src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    rev = "fd3c4ae5cd39f0651eda6a3a1a374278070135d6";
    hash = "sha256-8MqazKuwfFWVJ/yjT5fNrRzexFQ2ky4YTcZqOYjk9Qc=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "nanoarrow";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-nanoarrow";
    tag = "apache-arrow-nanoarrow-${finalAttrs.version}";
    hash = "sha256-1iLbT1eeyZaoB75uYTgg4qns+C7b4DErqMwJ9nQPRls=";
  };

  # Pre-populate the meson subproject with the flatcc source so meson doesn't try to download it.
  # The wrap's patch_directory overlay (meson.build) must also be applied.
  postPatch =
    let
      flatcc-src-dest = "subprojects/flatcc-${flatcc-src.rev}";
    in
    ''
      cp -r --no-preserve=mode ${flatcc-src} ${flatcc-src-dest}
      cp subprojects/packagefiles/flatcc/meson.build ${flatcc-src-dest}/
    '';

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [
    cython
    meson
    meson-python
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zlib
    zstd-c
  ];

  mesonFlags = [
    # Use system zstd instead of the meson wrap
    (lib.mesonOption "force_fallback_for" "flatcc")
  ];

  pythonImportsCheck = [ "nanoarrow" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python bindings to the nanoarrow C library";
    homepage = "https://github.com/apache/arrow-nanoarrow/tree/main/python";
    changelog = "https://github.com/apache/arrow-nanoarrow/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
