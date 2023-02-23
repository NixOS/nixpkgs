{ lib
, buildPythonPackage
, fetchPypi
, future
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "mdp";
  version = "3.6";

  src = fetchPypi {
    pname = "MDP";
    inherit version;
    hash = "sha256-rFKmUsy67RhX/xIJhi8Dv5sG0JOxJgb7QQeH2jqmWg4=";
  };

  propagatedBuildInputs = [ future numpy ];

  nativeCheckInputs = [ pytest ];

  doCheck = true;

  pythonImportsCheck = [ "mdp" "bimdp" ];

  postPatch = ''
    # https://github.com/mdp-toolkit/mdp-toolkit/issues/92
    substituteInPlace mdp/utils/routines.py --replace numx.typeDict numx.sctypeDict
  '';

  checkPhase = ''
    runHook preCheck

    pytest --seed 7710873 mdp
    pytest --seed 7710873 bimdp

    runHook postCheck
  '';

  meta = with lib; {
    description = "Library for building complex data processing software by combining widely used machine learning algorithms";
    homepage = "https://mdp-toolkit.sourceforge.net";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nico202 ];
  };
}
