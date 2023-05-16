{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
, requests
, lxml
, pandas
, pytestCheckHook
, pytest-recording
, responses
=======
, isPy27
, requests
, lxml
, pandas
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytrends";
<<<<<<< HEAD
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

  propagatedBuildInputs = [ requests lxml pandas ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-recording
    responses
  ];

  pytestFlagsArray = [
    "--block-network"
  ];

=======
  version = "4.9.0";
  disabled = isPy27; # python2 pandas is too old

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pU/B4xcUQrPI9cCApeId+Ae8T6rXeQzGK33bBZ6wqUs=";
  };

  propagatedBuildInputs = [ requests lxml pandas ];

  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "pytrends" ];

  meta = with lib; {
    description = "Pseudo API for Google Trends";
    homepage = "https://github.com/GeneralMills/pytrends";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mmahut ];
  };

}
