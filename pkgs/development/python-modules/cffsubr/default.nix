{ stdenv
, lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, fonttools
, pytestCheckHook
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "cffsubr";
  version = "0.2.9.post1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-azFBLc9JyPqEZkvahn4u3cVbb+b6aW/yU8TxOp/y/Fw=";
  };

  patches = [
    # https://github.com/adobe-type-tools/cffsubr/pull/23
    (fetchpatch {
      name = "remove-setuptools-git-ls-files.patch";
      url = "https://github.com/adobe-type-tools/cffsubr/commit/887a6a03b1e944b82fcb99b797fbc2f3a64298f0.patch";
      hash = "sha256-LuyqBtDrKWwCeckr+YafZ5nfVw1XnELwFI6X8bGomhs=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    fonttools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cffsubr" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Standalone CFF subroutinizer based on AFDKO tx";
    homepage = "https://github.com/adobe-type-tools/cffsubr";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
