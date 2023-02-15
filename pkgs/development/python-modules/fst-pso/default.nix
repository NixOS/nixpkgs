{ buildPythonPackage
, fetchPypi
, lib
, miniful
, numpy
}:

buildPythonPackage rec {
  pname = "fst-pso";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s9FuwnsLTTazWzBq9AwAzQs05eCp4wpx7QJJDolUomo=";
  };

  postPatch = ''
    2to3 --write --nobackups fstpso/surfaces.py
  '';

  propagatedBuildInputs = [
    miniful
    numpy
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "fstpso" ];

  meta = with lib; {
    description = "A settings-free global optimization method based on PSO and fuzzy logic";
    homepage = "https://github.com/aresio/fst-pso";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
