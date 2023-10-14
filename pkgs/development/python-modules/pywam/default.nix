{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pywam";
  version = "0.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ew33gz2Ddax4w4Zz7XTpMj+Pj8yy+tNsSpL1B6xYDQI=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "pywam" ];

  meta = with lib; {
    description = "Library built on AsyncIO for communicating with Samsung Wireless Audio speakers (WAM)";
    homepage = "https://github.com/Strixx76/pywam";
    changelog = "https://github.com/Strixx76/pywam/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    mainProgram = "pywam";
  };
}
