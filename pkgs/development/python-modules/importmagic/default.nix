{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "importmagic";
  version = "0.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P3dXpbdMmikeIOEgI7s79xvC+jrfsVoIVwZIq4Pq+Ng=";
  };

  patches = [
    # https://github.com/alecthomas/importmagic/issues/67
    ./python-312.patch
  ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "importmagic" ];

  meta = {
    description = "Python Import Magic - automagically add, remove and manage imports";
    homepage = "https://github.com/alecthomas/importmagic";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ onny ];
  };
}
