{ lib, buildPythonPackage, fetchPypi, beautifulsoup4, requests, click }:

buildPythonPackage rec {
  pname = "deep-translator";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iHK1A44SZqJ5N+D2ets76xuU0mryGT7TehM4wryB/AY=";
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
    description = "Flexible, free and unlimited Python tool to translate between different languages in a simple way using multiple translators";
    homepage = "https://deep-translator.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
