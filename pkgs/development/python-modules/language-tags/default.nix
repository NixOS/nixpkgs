{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "language-tags";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OnroerendErfgoed";
    repo = "language-tags";
    tag = version;
    hash = "sha256-T9K290seKhQLqW36EfA9kn3WveKCmyjN4Mx2j50qIEk=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "language_tags" ];

<<<<<<< HEAD
  meta = {
    description = "Dealing with IANA language tags in Python";
    homepage = "https://language-tags.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
=======
  meta = with lib; {
    description = "Dealing with IANA language tags in Python";
    homepage = "https://language-tags.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
