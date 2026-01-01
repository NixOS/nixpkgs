{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sabnzbd,
}:
buildPythonPackage rec {
  pname = "sabctools";
<<<<<<< HEAD
  version = "9.2.0";
=======
  version = "8.2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-fR0kJvT30psxuDYk1SfaeA/bC1HxVIV9KkkEOXe9OvM=";
=======
    hash = "sha256-olZSIjfP2E1tkCG8WzEZfrBJuDEp3PZyFFE5LJODEZE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "sabctools" ];

  passthru.tests = {
    inherit sabnzbd;
  };

<<<<<<< HEAD
  meta = {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ adamcstephens ];
=======
  meta = with lib; {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ adamcstephens ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
