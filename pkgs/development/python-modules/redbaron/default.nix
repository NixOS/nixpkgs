{
  lib,
  fetchPypi,
  buildPythonPackage,
  baron,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "redbaron";
  version = "0.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bqkq0wn20cc3qrcd1ifq74p4m570j345bkq4axl08kbr8whfba7";
  };

  propagatedBuildInputs = [ baron ];

  preCheck = ''
    rm -rf tests/__pycache__
    rm tests/test_bounding_box.py
  ''; # error about fixtures

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/redbaron";
    description = "Abstraction on top of baron, a FST for python to make writing refactoring code a realistic task";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
