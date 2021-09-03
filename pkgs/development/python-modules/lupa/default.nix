{ lib
, buildPythonPackage
, cython
, fetchPypi
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4lEbJ/OB9v22bvQNzFGCFQOBl0MbJBk1Z438PVEXgjE=";
  };

  nativeBuildInputs = [ cython ];

  pythonImportsCheck = [ "lupa" ];

  meta = with lib; {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
