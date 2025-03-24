{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "geohash";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vinsci";
    repo = "geohash";
    rev = "f31e613e1d2cf97c5e99e78dc2a88383c919b2f0";
    hash = "sha256-xFzFze/NwhLtfTJ1bIjRzNM3mbgTQ/a0suiqTymlKsE=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'docutils>=0.3'" "" # fake dep (testing)
  '';

  doCheck = false; # test is written in python2
  pythonImportCheck = [ "geohash" ];

  meta = {
    description = "Python module to decode/encode Geohashes to/from latitude and longitude";
    homepage = "https://github.com/darcy-r/geoparquet-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
