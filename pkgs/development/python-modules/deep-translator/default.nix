{ lib
, buildPythonPackage
, fetchPypi
, beautifulsoup4
, requests
, click
, pythonOlder
}:

buildPythonPackage rec {
  pname = "deep-translator";
  version = "1.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7VsEN6t9c0FMw0zHWnxnIyilQmQ127rXEfLrAYatKEc=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    requests
    click
  ];

  # Initializing it during build won't work as it needs connection with
  # APIs and the build environment is isolated (#148572 for details).
  # After built, it works as intended.
  #pythonImportsCheck = [ "deep_translator" ];

  # Again, initializing an instance needs network connection.
  # Tests will fail.
  doCheck = false;

  meta = with lib; {
    description = "Python tool to translate between different languages by using multiple translators";
    homepage = "https://deep-translator.readthedocs.io";
    changelog = "https://github.com/nidhaloff/deep-translator/releases/tag/v1.10.0";
    license = licenses.asl20;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
