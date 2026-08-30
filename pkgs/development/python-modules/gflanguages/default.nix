{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  protobuf,
  pytestCheckHook,
  regex,
  setuptools,
  setuptools-scm,
  uharfbuzz,
  youseedee,
  gfmetadata,
}:

buildPythonPackage (finalAttrs: {
  pname = "gflanguages";
  version = "0.7.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "lang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N7hFJ9qvb+i8j7NKGtJivFnrCKBE4tsvBAclrFBGFiw=";
  };

  # Relax the dependency on protobuf 3. Other packages in the Google Fonts
  # ecosystem have begun upgrading from protobuf 3 to protobuf 4,
  # so we need to use protobuf 4 here as well to avoid a conflict
  # in the closure of fontbakery. It seems to be compatible enough.
  pythonRelaxDeps = [ "protobuf" ];

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    protobuf
    regex
    gfmetadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    regex
    uharfbuzz
    youseedee
  ];

  pythonImportsCheck = [ "gflanguages" ];

  meta = {
    description = "Python library for Google Fonts language metadata";
    homepage = "https://github.com/googlefonts/lang";
    changelog = "https://github.com/googlefonts/lang/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      danc86
      jopejoe1
    ];
  };
})
