{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "progressbar33";
  version = "2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zvf6zs5hzrc03p9nfs4p16vhilqikycvv1yk0pxn8s07fdhvzji";
  };

  # no tests implemented
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://pypi.python.org/pypi/progressbar33";
    description = "Text progressbar library for python";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ twey ];
=======
  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/progressbar33";
    description = "Text progressbar library for python";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ twey ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
