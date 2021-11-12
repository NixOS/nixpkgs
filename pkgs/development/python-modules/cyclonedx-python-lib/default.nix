{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, packageurl-python
, poetry-core
, pytestCheckHook
, pythonOlder
, requirements-parser
, setuptools
, toml
, types-setuptools
, types-toml
, tox
}:

buildPythonPackage rec {
  pname = "cyclonedx-python-lib";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FNEtVTcmVyhAri55GjlzQbg21YByAJjmKQvWaYh3xRw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    importlib-metadata
    packageurl-python
    requirements-parser
    setuptools
    toml
    types-setuptools
    types-toml
  ];

  checkInputs = [
    pytestCheckHook
    tox
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools = "^50.3.2"' 'setuptools = "*"' \
      --replace 'importlib-metadata = "^4.8.1"' 'importlib-metadata = "*"'
  '';

  pythonImportsCheck = [
    "cyclonedx"
  ];

  meta = with lib; {
    description = "Python library for generating CycloneDX SBOMs";
    homepage = "https://github.com/CycloneDX/cyclonedx-python-lib";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
