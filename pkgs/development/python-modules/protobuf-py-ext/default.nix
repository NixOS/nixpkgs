{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "protobuf-py-ext";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  # No tag on GitHub for this release: bufbuild/protobuf-py's only tag is v0.2.0.
  # This has to stay in lockstep with protobuf-py, which is held at 0.1.1.
  src = fetchPypi {
    pname = "protobuf_py_ext";
    inherit (finalAttrs) version;
    hash = "sha256-A/Ycz8rVKi14SuybsLYIjg4y8USmw6s97tEvF/Hw0Ls=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-mLol3nFEQ+m9qzy95M39CPzmNUIixTGk5wgDjD2JVdg=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "protobuf_ext" ];

  # The test suite lives in the protobuf-py repository and covers this extension
  # only through protobuf-py's own tests, which the sdist does not ship.
  # pythonImportsCheck confirms the extension loads for this interpreter, which
  # is what packaging can get wrong.
  doCheck = false;

  meta = {
    description = "Native accelerator for the protobuf-py runtime";
    homepage = "https://github.com/bufbuild/protobuf-py";
    # The sdist declares no license; the source repository is Apache-2.0.
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mishushakov ];
  };
})
