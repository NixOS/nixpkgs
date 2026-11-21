{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lilypond,
}:

buildPythonPackage (finalAttrs: {
  pname = "jianpu-ly";
  version = "1.891";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "jianpu_ly";
    hash = "sha256-FFoGvJ/HEESk6tI1oYIq3Ilbsojrt1Pf/Bpu4WR79jw=";
  };

  build-system = [ setuptools ];

  dependencies = [ lilypond ];

  pythonImportsCheck = [ "jianpu_ly" ];

  # no tests in shipped with upstream
  doCheck = false;

  meta = {
    description = "Assists with printing jianpu";
    homepage = "https://ssb22.user.srcf.net/mwrhome/jianpu-ly.html";
    changelog = "https://github.com/ssb22/jianpu-ly/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ifurther ];
  };
})
