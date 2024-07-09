{
  lib,
  buildPythonPackage,
  fetchPypi,
  pefile,
  pillow,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "icoextract";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-/UxnWNyRNtwI4Rxx97i5QyjeMrUr5Sq+TfLTmU0xWyc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pefile
    pillow
  ];

  # tests expect mingw and multiarch
  doCheck = false;

  pythonImportsCheck = [ "icoextract" ];

  postInstall = ''
    mkdir -p $out/share/thumbnailers
    substituteAll ${./exe-thumbnailer.thumbnailer} $out/share/thumbnailers/exe-thumbnailer.thumbnailer
  '';

  meta = with lib; {
    description = "Extract icons from Windows PE files";
    homepage = "https://github.com/jlu5/icoextract";
    changelog = "https://github.com/jlu5/icoextract/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      bryanasdev000
      donovanglover
    ];
  };
}
