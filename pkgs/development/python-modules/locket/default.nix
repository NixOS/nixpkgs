{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "locket";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XA1MBSqLu/dQ4Fao5lzNMJCG9PDxii6sMGqN+kESpjI=";
  };

  # weird test requirements (spur.local>=0.3.7,<0.4)
  doCheck = false;

  pythonImportsCheck = [ "locket" ];

  meta = with lib; {
    description = "Library which provides a lock that can be used by multiple processes";
    homepage = "https://github.com/mwilliamson/locket.py";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
