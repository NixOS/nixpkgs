{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  zetup,
  six,
  moretools,
  path,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "modeled";
  version = "0.1.8";
  format = "setuptools";

  src = fetchPypi {
    extension = "zip";
    inherit pname version;
    sha256 = "1wcl3r02q10gxy4xw7g8x2wg2sx4sbawzbfcl7a5xdydrxl4r4v4";
  };

  buildInputs = [ zetup ];

  propagatedBuildInputs = [
    six
    moretools
    path
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "modeled" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken =
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    description = "Universal data modeling for Python";
    homepage = "https://github.com/modeled/modeled";
<<<<<<< HEAD
    license = lib.licenses.lgpl3Only;
=======
    license = licenses.lgpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
