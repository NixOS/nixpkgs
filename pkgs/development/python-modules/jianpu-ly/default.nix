{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lilypond,
}:

buildPythonPackage rec {
  pname = "jianpu-ly";
<<<<<<< HEAD
  version = "1.865";
=======
  version = "1.864";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "jianpu_ly";
<<<<<<< HEAD
    hash = "sha256-fW4qoaDrOZL+oKRPWIZbvuZSOCsrWDw0QsO4r6SJB/Y=";
=======
    hash = "sha256-dYAUpdHvLnN4pE3aBZBK0yLjUQYguqBcAXPq7ep/iNE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [ lilypond ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "jianpu_ly" ];

  # no tests in shipped with upstream
  doCheck = false;

  meta = {
    homepage = "https://ssb22.user.srcf.net/mwrhome/jianpu-ly.html";
    description = "Assists with printing jianpu";
    changelog = "https://github.com/ssb22/jianpu-ly/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ifurther ];
  };
}
