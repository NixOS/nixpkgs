{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  palettable,
  pandas,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "mizani";
  version = "0.11.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "mizani";
    rev = "refs/tags/v${version}";
    hash = "sha256-2XBvjlVSEjeNc7UlPZ00cNrWVuHh/FgDwkvWus7ndr4=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    matplotlib
    palettable
    pandas
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=mizani --cov-report=xml" ""
  '';

  pythonImportsCheck = [ "mizani" ];

  meta = with lib; {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    changelog = "https://github.com/has2k1/mizani/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
