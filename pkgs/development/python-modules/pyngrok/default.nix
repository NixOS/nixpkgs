{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "7.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9oS/iBuAWQ3COlnhgeN0e7CFj6VNbkfpPe35tO0BSpo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = with lib; {
    description = "A Python wrapper for ngrok";
    homepage = "https://github.com/alexdlaird/pyngrok";
    changelog = "https://github.com/alexdlaird/pyngrok/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
