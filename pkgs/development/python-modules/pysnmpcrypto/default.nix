{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  cryptography,
  pycryptodomex,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysnmpcrypto";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tjX7Ox7GY3uaADP1BQYhThbrhFdLHSWrAnu95MqlUSk=";
  };

  postPatch = ''
    # ValueError: invalid literal for int() with base 10: 'post0' in File "<string>", line 104, in <listcomp>
    substituteInPlace setup.py --replace \
      "observed_version = [int(x) for x in setuptools.__version__.split('.')]" \
      "observed_version = [36, 2, 0]"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    pycryptodomex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysnmpcrypto" ];

  meta = with lib; {
    description = "Strong crypto support for Python SNMP library";
    homepage = "https://github.com/etingof/pysnmpcrypto";
    changelog = "https://github.com/etingof/pysnmpcrypto/blob/${version}/CHANGES.txt";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
