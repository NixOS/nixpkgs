{ lib
, buildPythonPackage
, fetchPypi
, lxml
, translatehtml
}:

buildPythonPackage rec {
  pname = "argos-translate-files";
  version = "1.1.4";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YSTqqd+Kv2QVlAjA0lf4IRx7rJ1DmvB0JIReBv3yZcM=";
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
