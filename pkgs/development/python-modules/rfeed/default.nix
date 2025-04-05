{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:
buildPythonPackage rec {
  pname = "rfeed";
  version = "1.1.1";
  pyproject = true;

  build-system = [ setuptools ];
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qpUG8oZrdPWjItOUoUpjwZpoJcLZR1X/GdRt0eJDSBk=";
  };

  pythonImportsCheck = [ "rfeed" ];
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail distutils.core setuptools
  '';
  meta = {
    description = "Extensible RSS 2.0 Feed Generator written in Python.";
    downloadPage = "https://github.com/egorsmkv/rfeed/releases";
    homepage = "https://github.com/egorsmkv/rfeed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

