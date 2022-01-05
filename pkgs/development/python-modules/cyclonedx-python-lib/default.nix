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
  version = "0.12.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = pname;
    rev = "v${version}";
    sha256 = "1404wcwjglq025n8ncsrl2h64g1sly83cs9sc6jpiw1g5ay4a1vi";
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
