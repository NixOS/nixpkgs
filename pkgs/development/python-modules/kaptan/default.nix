{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kaptan";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EBMwpE/e3oiFhvMBC9FFwOxIpIBrxWQp+lSHpndAIfg=";
  };

  postPatch = ''
    sed -i "s/==.*//g" requirements/test.txt

    substituteInPlace requirements/base.txt --replace 'PyYAML>=3.13,<6' 'PyYAML>=3.13'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Configuration manager for python applications";
    mainProgram = "kaptan";
    homepage = "https://kaptan.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
