{ lib
, buildPythonPackage
, colorama
, fetchPypi
, pillow
}:

buildPythonPackage rec {
  pname = "ascii-magic";
  version = "1.6";

  src = fetchPypi {
    pname = "ascii_magic";
    inherit version;
    sha256 = "sha256-faVRj3No5z8R4hUaDAYIBKoUniZ7Npt+52U/vXsEalE=";
  };

  propagatedBuildInputs = [
    colorama
    pillow
  ];

  # Project is not tagging releases and tests are not shipped with PyPI source
  doCheck = false;

  pythonImportsCheck = [
    "ascii_magic"
  ];

  meta = with lib; {
    description = "Python module to converts pictures into ASCII art";
    homepage = "https://github.com/LeandroBarone/python-ascii_magic";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
