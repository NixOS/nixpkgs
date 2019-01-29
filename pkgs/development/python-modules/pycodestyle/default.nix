{ lib, buildPythonPackage, fetchPypi, fetchpatch }:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbfca99bd594a10f674d0cd97a3d802a1fdef635d4361e1a2658de47ed261e3a";
  };

  patches = [
    # https://github.com/PyCQA/pycodestyle/pull/801
    (fetchpatch {
      url = https://github.com/PyCQA/pycodestyle/commit/397463014fda3cdefe8d6c9d117ae16d878dc494.patch;
      sha256 = "01zask2y2gim5il9lcmlhr2qaadv9v7kaw1y619l8xbjhpbq2zh8";
    })
  ];

  meta = with lib; {
    description = "Python style guide checker (formerly called pep8)";
    homepage = https://pycodestyle.readthedocs.io;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
