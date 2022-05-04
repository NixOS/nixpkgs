{ lib
, buildPythonPackage
, cython
, fetchPypi
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4dlKwqYw0nECfawsIdFCh3HZ6p1NiPFfIKd4E0DwKk4=";
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
