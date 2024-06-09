{
  lib,
  cbc,
  amply,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pulp";
  version = "2.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lpbk1GeC8F/iLGV8G5RPHghnaM9eL82YekUYEt9+mvc=";
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

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pulp" ];

  meta = with lib; {
    description = "Module to generate MPS or LP files";
    mainProgram = "pulptest";
    homepage = "https://github.com/coin-or/pulp";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
