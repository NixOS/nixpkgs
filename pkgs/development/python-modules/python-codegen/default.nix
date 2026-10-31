{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-codegen";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andreif";
    repo = "codegen";
    tag = "${finalAttrs.version}";
    hash = "sha256-SCYXTQzDVgVIfskKGEHhW73uT0M8E0KDLVj/RQ5XKOc=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "License :: OSI Approved :: BSD" ""
  '';

  pythonImportsCheck = [ "codegen" ];

  meta = {
    description = "Extension to ast that allows ast -> python code generation";
    homepage = "https://github.com/andreif/codegen";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aiyion ];
  };
})
