{ lib
, buildPythonPackage
, cython
, fetchPypi
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13ifv0nxbf70xg69sp49j484m8cnid7rgh8f94pgfb50dj01vqd3";
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
