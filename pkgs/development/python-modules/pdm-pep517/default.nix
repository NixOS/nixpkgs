{
  lib,
  buildPythonPackage,
  fetchPypi,
  gitMinimal,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pdm-pep517";
  version = "1.1.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f0kSHnC0Lcopb6yWIhDdLaB6OVdfxWcxN61mFjOyzz8=";
  };

  preCheck = ''
    HOME=$TMPDIR

    git config --global user.name nobody
    git config --global user.email nobody@example.com
  '';

  nativeCheckInputs = [
    pytestCheckHook
    gitMinimal
    setuptools
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/pdm-project/pdm-pep517";
    description = "Yet another PEP 517 backend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
=======
  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-pep517";
    description = "Yet another PEP 517 backend";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
