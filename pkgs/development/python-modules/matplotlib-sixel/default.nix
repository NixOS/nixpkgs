{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  imagemagick,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "matplotlib-sixel";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JXOb1/IacJV8bhDvF+OPs2Yg1tgRDOqwiAQfiSKTlew=";
  };

  build-system = [ setuptools ];

  dependencies = [ matplotlib ];

  postPatch = ''
    substituteInPlace sixel/sixel.py \
      --replace-fail 'Popen(["convert",' 'Popen(["${imagemagick}/bin/convert",'
  '';

  pythonImportsCheck = [ "sixel" ];

  meta = with lib; {
    description = "Sixel graphics backend for matplotlib";
    homepage = "https://github.com/jonathf/matplotlib-sixel";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
