{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  uv-build,

  # dependencies
  protobuf-py-ext,
  protobuf-py-pure,
}:

buildPythonPackage (finalAttrs: {
  pname = "protobuf-py";
  # connectrpc requires this exact version and e2b requires <0.2; bump all three
  # together.
  version = "0.7.0";
  pyproject = true;

  # No tag on GitHub for this release: bufbuild/protobuf-py's only tag is v0.2.0,
  # which connectrpc (`protobuf-py==0.1.1`) and e2b (`<0.2`) do not accept yet.
  src = fetchPypi {
    pname = "protobuf_py";
    inherit (finalAttrs) version;
    hash = "sha256-LOxHwEYvjQv8Ghy76c92bsZcqVEwcA8K/rli6dfTRU8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.13,<0.14" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    protobuf-py-ext
    protobuf-py-pure
  ];

  pythonImportsCheck = [ "protobuf" ];

  # The test suite is not part of the PyPI sdist and there is no git tag for this
  # release. Note that protobuf swallows an ImportError from protobuf_ext and
  # falls back to pure Python, so a broken accelerator would not surface here —
  # protobuf-py-ext's own pythonImportsCheck is what guards that.
  doCheck = false;

  meta = {
    description = "Idiomatic Protocol Buffers for Python";
    homepage = "https://github.com/bufbuild/protobuf-py";
    changelog = "https://github.com/bufbuild/protobuf-py/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mishushakov ];
  };
})
