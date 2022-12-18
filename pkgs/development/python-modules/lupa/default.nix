{ lib
, buildPythonPackage
, cython
, fetchPypi
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "1.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0P1OYK0Un+JckFMOKg4DKkKm8EVfKcoO24Fw1ux1HG4=";
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
