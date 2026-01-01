{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  mock,
}:
buildPythonPackage rec {
  pname = "hiro";
  version = "1.1.1";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;

    hash = "sha256-2jM5rx3JpZTMqdycccclJysuMGYE5F0OBXXNE8X5XWg=";
  };

  propagatedBuildInputs = [
    six
    mock
  ];

<<<<<<< HEAD
  meta = {
    description = "Time manipulation utilities for Python";
    homepage = "https://hiro.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyarly ];
=======
  meta = with lib; {
    description = "Time manipulation utilities for Python";
    homepage = "https://hiro.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ nyarly ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
