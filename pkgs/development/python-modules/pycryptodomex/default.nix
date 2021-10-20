{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VBzT4+JS+xmntI9CC3mLU0gzArf+TZlUyUdgXQomPWI=";
  };

  pythonImportsCheck = [ "Cryptodome" ];

  meta = with lib; {
    description = "A self-contained cryptographic library for Python";
    homepage = "https://www.pycryptodome.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
