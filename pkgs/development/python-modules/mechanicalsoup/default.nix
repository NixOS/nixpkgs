{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytest-httpbin
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "mechanicalsoup";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MechanicalSoup";
    repo = "MechanicalSoup";
    rev = "v${version}";
    hash = "sha256-Q5oDAgAZYYUYqjDByXNXFNVKmRyjzIGVE4LN9j8vk4c=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    requests
  ];

  nativeCheckInputs = [
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

  pythonImportsCheck = [
    "mechanicalsoup"
  ];

  meta = with lib; {
    description = "Python library for automating interaction with websites";
    homepage = "https://github.com/hickford/MechanicalSoup";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich fab ];
  };
}
