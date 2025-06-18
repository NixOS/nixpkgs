{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  translatehtml,
}:

buildPythonPackage rec {
  pname = "argos-translate-files";
  version = "1.2.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vIwZ2jdrBXtz6gG+Zfgqq6HVfdzmQf7nLqCDaQZT4js=";
  };

  propagatedBuildInputs = [
    lxml
    translatehtml
  ];

  postPatch = ''
    ln -s */requires.txt requirements.txt
  '';

  # required for import check to work (argostranslate)
  env.HOME = "/tmp";

  pythonImportsCheck = [ "argostranslatefiles" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Translate files using Argos Translate";
    homepage = "https://www.argosopentech.com";
    license = licenses.mit;
    maintainers = with maintainers; [ misuzu ];
  };
}
