{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "odfpy";
  version = "1.3.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f8163f8464868cff9421a058f25566e41d73c8f7e849c021b86630941b44366";
  };

  checkPhase = ''
    pushd tests
    rm runtests
    for file in test*.py; do
        python  $file
    done
  '';

  meta = {
    description = "Python API and tools to manipulate OpenDocument files";
    homepage = "https://joinup.ec.europa.eu/software/odfpy/home";
    license = lib.licenses.asl20;
  };
}
