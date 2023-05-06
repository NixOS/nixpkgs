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
  version = "1.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "deep_translator";
    inherit version;
    hash = "sha256-6ZQ42rcOO+vNqTLj9ehv09MrQ/h9Zu2fi2gW2xRvHZ8=";
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
