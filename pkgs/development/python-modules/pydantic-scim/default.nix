{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-scim";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chalk-ai";
    repo = "pydantic-scim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hbc94v/+slXRGDKKbMui8WPwn28/1XcKvHkbLebWtj0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version=get_version(),' 'version="${finalAttrs.version}",'
  '';

  propagatedBuildInputs = [ pydantic ] ++ pydantic.optional-dependencies.email;

  pythonImportsCheck = [ "pydanticscim" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Pydantic types for SCIM";
    homepage = "https://github.com/chalk-ai/pydantic-scim";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
