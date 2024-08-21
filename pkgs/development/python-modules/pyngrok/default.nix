{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "7.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TkOvmy8hzu2NITeXAo/ogjAD8YW0l5Lk04MwI2XIFRU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pyyaml ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = with lib; {
    description = "Python wrapper for ngrok";
    homepage = "https://github.com/alexdlaird/pyngrok";
    changelog = "https://github.com/alexdlaird/pyngrok/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
