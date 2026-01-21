{
  lib,
  cbc,
  amply,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pulp";
  version = "3.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "pulp";
    tag = version;
    hash = "sha256-b9qTJqSC8G3jxcqS4mkQ1gOLLab+YzYaNClRwD6I/hk=";
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

  meta = {
    description = "Module to generate MPS or LP files";
    mainProgram = "pulptest";
    homepage = "https://github.com/coin-or/pulp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
