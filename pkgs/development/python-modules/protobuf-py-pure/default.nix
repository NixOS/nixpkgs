{
  lib,
  buildPythonPackage,
  fetchPypi,
  uv-build,
  typing-extensions,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "protobuf-py-pure";
  version = "0.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "protobuf_py_pure";
    inherit (finalAttrs) version;
    hash = "sha256-RyujC08dipXIK4jcKquklk3j4YP9dZM0OEXkSpL3jt4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.13,<0.14" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "protobuf" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pure Python implementation of protobuf-py, idiomatic Protocol Buffers for Python";
    homepage = "https://pypi.org/project/protobuf-py-pure";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
