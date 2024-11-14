{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  requests,
  lxml,
  pandas,
  pytestCheckHook,
  pytest-recording,
  responses,
}:

buildPythonPackage rec {
  pname = "pytrends";
  version = "4.9.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aRxuNrGuqkdU82kr260N/0RuUo/7BS7uLn8TmqosaYk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'addopts = "--cov pytrends/"' ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    requests
    lxml
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-recording
    responses
  ];

  pytestFlagsArray = [ "--block-network" ];

  pythonImportsCheck = [ "pytrends" ];

  meta = with lib; {
    description = "Pseudo API for Google Trends";
    homepage = "https://github.com/GeneralMills/pytrends";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mmahut ];
  };
}
