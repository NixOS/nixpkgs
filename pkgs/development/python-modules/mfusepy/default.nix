{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fuse3,
}:

let
  version = "3.0.0";
in
buildPythonPackage {
  pname = "mfusepy";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mxmlnkn";
    repo = "mfusepy";
    tag = "v${version}";
    hash = "sha256-a0F8zcPfKwkYgbXMrLZZ3+kkMfn+ohqoBFa98yNr8uE=";
  };

  postPatch = ''
    substituteInPlace mfusepy.py \
      --replace-fail "_libfuse_path = os.environ.get('FUSE_LIBRARY_PATH')" '_libfuse_path = "${lib.getLib fuse3}/lib/libfuse3.so.4"'
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mfusepy" ];

  meta = {
    description = "Ctypes bindings for the high-level API in libfuse 2 and 3";
    homepage = "https://github.com/mxmlnkn/mfusepy";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
