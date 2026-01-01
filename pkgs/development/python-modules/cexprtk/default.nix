{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
<<<<<<< HEAD
  setuptools,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "cexprtk";
<<<<<<< HEAD
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sBLkHco0u2iEsdUxmPW2ONP/Fe08p0fOVJLmzz3t4os=";
  };

  build-system = [ setuptools ];

=======
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QhftIybufVPO/YbLFycR4qYEAtQMcRPP5jKS6o6dFZg=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cexprtk" ];

<<<<<<< HEAD
  meta = {
    description = "Mathematical expression parser, cython wrapper";
    homepage = "https://github.com/mjdrushton/cexprtk";
    changelog = "https://github.com/mjdrushton/cexprtk/blob/${version}/CHANGES.md";
    license = lib.licenses.cpl10;
    maintainers = with lib.maintainers; [ onny ];
=======
  meta = with lib; {
    description = "Mathematical expression parser, cython wrapper";
    homepage = "https://github.com/mjdrushton/cexprtk";
    license = licenses.cpl10;
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
