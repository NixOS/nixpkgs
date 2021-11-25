{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, pkgs
, numpy
, scipy
  # check inputs
, nose
}:

buildPythonPackage rec {
  pname = "ecos";
  version = "2.0.8";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos-python";
    rev = version;
    sha256 = "sha256-2OJqbcOZceeD2fO5cu9fohuUVaA2LwQOQSWR4jRv3mk=";
    fetchSubmodules = true;
  };

  prePatch = ''
    echo '__version__ = "${version}"' >> ./src/ecos/version.py
  '';

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  checkInputs = [ nose ];
  checkPhase = ''
    # Run tests
    cd ./src
    nosetests test_interface.py test_interface_bb.py
  '';
  pythonImportsCheck = [ "ecos" ];

  meta = with lib; {
    description = "Python package for ECOS: Embedded Cone Solver";
    downloadPage = "https://github.com/embotech/ecos-python/releases";
    homepage = pkgs.ecos.meta.homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
