{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  flake8,
}:

buildPythonPackage rec {
  pname = "pure-cdb";
  version = "4.0.0";
  format = "setuptools";

  # Archive on pypi has no tests.
  src = fetchFromGitHub {
    owner = "bbayles";
    repo = "python-pure-cdb";
    tag = "v${version}";
    hash = "sha256-7zxQO+oTZJhXfM2yijGXchLixiQRuFTOSESVlEc+T0s=";
  };

  nativeCheckInputs = [ flake8 ];

  pythonImportsCheck = [ "cdblib" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for working with constant databases";
    homepage = "https://python-pure-cdb.readthedocs.io/en/latest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
=======
  meta = with lib; {
    description = "Python library for working with constant databases";
    homepage = "https://python-pure-cdb.readthedocs.io/en/latest";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
