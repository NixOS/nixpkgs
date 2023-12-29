{ lib
, cbc
, amply
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pulp";
  version = "2.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-j0f6OiscJyTqPNyLp0qWRjCGLWuT3HdU1S/sxpnsiMo=";
  };

  postPatch = ''
    sed -i pulp/pulp.cfg.linux \
      -e 's|CbcPath = .*|CbcPath = ${cbc}/bin/cbc|' \
      -e 's|PulpCbcPath = .*|PulpCbcPath = ${cbc}/bin/cbc|'
  '';

  propagatedBuildInputs = [
    amply
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pulp"
  ];

  meta = with lib; {
    description = "Module to generate MPS or LP files";
    homepage = "https://github.com/coin-or/pulp";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
