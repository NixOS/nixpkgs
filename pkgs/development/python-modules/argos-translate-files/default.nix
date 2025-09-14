{
  lib,
  buildPythonPackage,
  fetchPypi,
  writableTmpDirAsHomeHook,
  setuptools,
  lxml,
  pymupdf,
  pysrt,
  translatehtml,
}:

buildPythonPackage rec {
  pname = "argos-translate-files";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9ufNuExfyW3gr8+pIpp6Ie03e0hE4l3l3kk6EiVH0x8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    pymupdf
    pysrt
    translatehtml
  ];

  nativeCheckInputs = [
    # pythonImportsCheck needs a home dir for argostranslatefiles
    writableTmpDirAsHomeHook
  ];

  postPatch = ''
    ln -s */requires.txt requirements.txt
  '';

  pythonImportsCheck = [ "argostranslatefiles" ];

  meta = with lib; {
    description = "Translate files using Argos Translate";
    homepage = "https://www.argosopentech.com";
    license = licenses.mit;
    maintainers = with maintainers; [ misuzu ];
  };
}
