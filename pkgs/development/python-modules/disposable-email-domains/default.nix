{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "disposable-email-domains";
<<<<<<< HEAD
  version = "0.0.153";
=======
  version = "0.0.151";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  # No tags on GitHub
  src = fetchPypi {
    pname = "disposable_email_domains";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-b4C/OKBMR48lJ5+e1Mx7PJO2ZvITvar213qYkrFnmV0=";
=======
    hash = "sha256-jXtOepZPvp2jlOWJ1Lp2ltnrWU3qL5jHunPRcPLZc8E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "disposable_email_domains" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Set of disposable email domains";
    homepage = "https://github.com/disposable-email-domains/disposable-email-domains";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
