{ lib
, aiohttp
, buildPythonPackage
, colorlog
, fetchFromGitHub
, python-dateutil
, pythonOlder
, requests
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pyisy";
  version = "3.1.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "automicus";
    repo = "PyISY";
    rev = "refs/tags/v${version}";
    hash = "sha256-OvWdKr8RlXRnAUMHSPhJDacvKeRa8QGPmGPQWLG2ouk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version_format="{tag}"' 'version="${version}"'
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    colorlog
    python-dateutil
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyisy" ];

  meta = with lib; {
    description = "Python module to talk to ISY994 from UDI";
    homepage = "https://github.com/automicus/PyISY";
    changelog = "https://github.com/automicus/PyISY/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
