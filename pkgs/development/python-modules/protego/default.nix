{ lib
, buildPythonPackage
, fetchPypi
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

  meta = with lib; {
    description = "A pure-Python robots.txt parser with support for modern conventions";
    homepage = "https://github.com/scrapy/protego";
    changelog = "https://github.com/scrapy/protego/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
