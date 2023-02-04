{ lib
, buildPythonPackage
, fetchPypi
, future
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "MDP";
  version = "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac52a652ccbaed1857ff1209862f03bf9b06d093b12606fb410787da3aa65a0e";
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
    homepage = "http://mdp-toolkit.sourceforge.net";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nico202 ];
  };
}
