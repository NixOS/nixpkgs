{ lib
, buildPythonPackage
, fetchFromGitHub
, plumbum
, requests
, setuptools
, hypothesis
, nose
, responses
}:

buildPythonPackage rec {
  pname = "habitipy";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ASMfreaK";
    repo = "habitipy";
    rev = "v${version}";
    sha256 = "1vf485z5m4h61p64zr3sgkcil2s3brq7dja4n7m49d1fvzcirylv";
  };

  propagatedBuildInputs = [
    plumbum
    requests
    setuptools
  ];

  nativeCheckInputs = [
    hypothesis
    nose
    responses
  ];

  checkPhase = ''
    HOME=$TMPDIR nosetests
  '';

  pythonImportsCheck = [ "habitipy" ];

  meta = with lib; {
    description = "Tools and library for Habitica restful API";
    homepage = "https://github.com/ASMfreaK/habitipy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
