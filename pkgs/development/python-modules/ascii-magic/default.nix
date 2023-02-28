{ lib
, buildPythonPackage
, colorama
, fetchPypi
, pillow
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ascii-magic";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ascii_magic";
    inherit version;
    hash = "sha256-PtQaHLFn3u1cz8YotmnzWjoD9nvdctzBi+X/2KJkPYU=";
  };

  propagatedBuildInputs = [
    colorama
    pillow
  ];

  # Project is not tagging releases and tests are not shipped with PyPI source
  # https://github.com/LeandroBarone/python-ascii_magic/issues/10
  doCheck = false;

  pythonImportsCheck = [
    "ascii_magic"
  ];

  meta = with lib; {
    description = "Python module to converts pictures into ASCII art";
    homepage = "https://github.com/LeandroBarone/python-ascii_magic";
    changelog = "https://github.com/LeandroBarone/python-ascii_magic#changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
