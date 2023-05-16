{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "protego";
  version = "0.3.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "Protego";
    hash = "sha256-BCKL/95Ma8ujHPZSm6LP1uG3CAj9wdLLQwG+ayjWxWg=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "protego" ];
=======
, six
, pytest
}:

buildPythonPackage rec {
  pname = "Protego";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-32ZtQwTat3Ti3J/rIIuxrI1x6lzuwS9MmeujD71kL/I=";
  };
  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest tests
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A pure-Python robots.txt parser with support for modern conventions";
    homepage = "https://github.com/scrapy/protego";
<<<<<<< HEAD
    changelog = "https://github.com/scrapy/protego/blob/${version}/CHANGELOG.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
