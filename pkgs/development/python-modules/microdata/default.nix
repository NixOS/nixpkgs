{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  html5lib,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "microdata";
  version = "0.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "edsu";
    repo = "microdata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BAygCLBLxZ033ZWRFSR52dSM2nPY8jXplDXQ8WW3KPo=";
  };

  propagatedBuildInputs = [ html5lib ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "microdata" ];

  meta = {
    description = "Library for extracting html microdata";
    mainProgram = "microdata";
    homepage = "https://github.com/edsu/microdata";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
