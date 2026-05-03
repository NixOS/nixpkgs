{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  filelock,
}:

buildPythonPackage (finalAttrs: {
  pname = "cx-logging";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthony-tuininga";
    repo = "cx_Logging";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aBLIzjkB0X8jboEQ3CNHLBPX5Mx1IJjmPKvJRqcfozI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=70.1,<75" "setuptools"
  ''
  # The flag -soname isn't recognized by the linker on darwin. Only -install_name is valid.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace setup.py \
      --replace-fail "-soname" "-install_name"
  '';

  build-system = [ setuptools ];

  dependencies = [ filelock ];

  pythonImportsCheck = [ "cx_Logging" ];

  meta = {
    description = "Python and C interfaces for logging";
    changelog = "https://github.com/anthony-tuininga/cx_Logging/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
