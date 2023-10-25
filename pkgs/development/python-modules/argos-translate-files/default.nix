{ lib
, buildPythonPackage
, fetchPypi
, lxml
, translatehtml
}:

buildPythonPackage rec {
  pname = "argos-translate-files";
  version = "1.1.3";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6931ea8fbabdc24903ceaabfe848be0fa4a0477d00451a8dfbc1525b623f0ba";
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
