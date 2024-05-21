{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyric";
  version = "0.1.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyRIC";
    inherit version;
    hash = "sha256-tTmwHK/r0kBsAAl/lFJeoPjs0d2S93MfQ+rA7xbCzMk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "__version__ = '0.0.3'" "__version__ = '${version}'"
  '';

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [
    "pyric"
  ];

  meta = with lib; {
    description = "Python Radio Interface Controller";
    homepage = "https://github.com/wraith-wireless/PyRIC";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
