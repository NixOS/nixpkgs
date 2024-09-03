{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  colored,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "ansitable";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ehPPpZ9C/Nrly9WoJJfZtv2YfZ9MEcQsKtuxNpcJe7U=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ colored ];

  pythonImportsCheck = [ "ansitable" ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  meta = with lib; {
    description = "Quick and easy display of tabular data and matrices with optional ANSI color and borders";
    homepage = "https://pypi.org/project/ansitable/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
