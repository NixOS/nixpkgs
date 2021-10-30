{ lib
, beautifulsoup4
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, lxml
, pytest-httpbin
, pytest-mock
, pytestCheckHook
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "mechanicalsoup";
  version = "1.1.0";

  disabled = ! pythonAtLeast "3.6";

  src = fetchFromGitHub {
    owner = "MechanicalSoup";
    repo = "MechanicalSoup";
    rev = "v${version}";
    sha256 = "1mly0ivai3rx64frk7a7ra6abhdxm9x3l6s6x7sgrl9qx1z8zsp3";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    requests
  ];

  checkInputs = [
    pytest-httpbin
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    # Is in setup_requires but not used in setup.py
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
    substituteInPlace setup.cfg \
      --replace " --cov --cov-config .coveragerc --flake8" ""
  '';

  pythonImportsCheck = [ "mechanicalsoup" ];

  meta = with lib; {
    description = "Python library for automating interaction with websites";
    homepage = "https://github.com/hickford/MechanicalSoup";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich fab ];
  };
}
