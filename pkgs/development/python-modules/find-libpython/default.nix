{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "find-libpython";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "find_libpython";
    sha256 = "sha256-bn/l2a9/rW3AZstVFaDpyQpx8f6yuy+OTNu0+DJ26eU=";
  };

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "find_libpython" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Finds the libpython associated with your environment, wherever it may be hiding";
    changelog = "https://github.com/ktbarrett/find_libpython/releases/tag/${version}";
    homepage = "https://github.com/ktbarrett/find_libpython";
    license = licenses.mit;
    maintainers = with maintainers; [ jleightcap ];
  };
}
