{ lib
, buildPythonPackage
, decorator
, fetchPypi
, formencode
, httpretty
, libxml2
, lxml
, mock
, nocasedict
, nocaselist
, pbr
, ply
, pytest
, pythonOlder
, pytz
, pyyaml
, requests
, requests-mock
, six
, testfixtures
, yamlloader
}:

buildPythonPackage rec {
  pname = "pywbem";
<<<<<<< HEAD
  version = "1.6.2";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-JugXm8F+MXa0zVdrn1p3MPhI1RvgUTdo/X8x/ZsnCpY=";
=======
    hash = "sha256-4mqwMkR17lMp10lx+UK0sxW2rA7a8njnDha1YDJ475g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    mock
    nocasedict
    nocaselist
    pbr
    ply
    pyyaml
    six
    yamlloader
  ];

  nativeCheckInputs = [
    decorator
    formencode
    httpretty
    libxml2
    lxml
    pytest
    pytz
    requests
    requests-mock
    testfixtures
  ];

  pythonImportsCheck = [
    "pywbem"
  ];

  meta = with lib; {
    description = "Support for the WBEM standard for systems management";
    homepage = "https://pywbem.github.io";
    changelog = "https://github.com/pywbem/pywbem/blob/${version}/docs/changes.rst";
    license = licenses.lgpl21Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ peterhoeg ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
