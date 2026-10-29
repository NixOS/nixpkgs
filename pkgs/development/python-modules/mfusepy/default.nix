{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fuse3,
}:

let
  version = "3.1.1";
in
buildPythonPackage {
  pname = "mfusepy";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mxmlnkn";
    repo = "mfusepy";
    tag = "v${version}";
    hash = "sha256-k7CxATpFTIZfQxnz8aYuyeooFY64JZl7Z8jfH2CtehM=";
  };

  # upstream pins setuptools < 83 because of backward-incompatible license
  # file specification change; nixpkgs has setuptools 83 which still works
  # (deprecation warning only, see pyproject.toml for the full context)
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail '"setuptools >= 61, < 83"' '"setuptools >= 61"'
  ''
  # If fuse library path cannot be found, use fuse library path in nixpkgs
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace mfusepy.py \
      --replace-fail "_libfuse_path = find_library('fuse3')" '_libfuse_path = "${lib.getLib fuse3}/lib/libfuse3.so.4"'
  '';

  build-system = [ setuptools ];

  # https://github.com/NixOS/nixpkgs/blob/1e1947e8b7962c914b725e8b821e311229e632ae/doc/packages/fuse.section.md?plain=1#L10
  pythonImportsCheck = lib.optionals stdenv.hostPlatform.isLinux [ "mfusepy" ];

  meta = {
    description = "Ctypes bindings for the high-level API in libfuse 2 and 3";
    homepage = "https://github.com/mxmlnkn/mfusepy";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
