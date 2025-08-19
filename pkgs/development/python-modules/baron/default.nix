{
  lib,
  fetchPypi,
  buildPythonPackage,
  rply,
  pytestCheckHook,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "baron";
  version = "0.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af822ad44d4eb425c8516df4239ac4fdba9fdb398ef77e4924cd7c9b4045bc2f";
  };

  propagatedBuildInputs = [ rply ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = isPy3k;

  meta = with lib; {
    homepage = "https://github.com/PyCQA/baron";
    description = "Abstraction on top of baron, a FST for python to make writing refactoring code a realistic task";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
