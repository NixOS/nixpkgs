{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  setuptools,

  unittestCheckHook,
}:

buildPythonPackage {
  pname = "ecoji";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mecforlove";
    repo = "ecoji-py";
    # no tags on github
    rev = "bc021cf1c78263aa3d07e2db9016637caf26d2b7";
    hash = "sha256-mfgw9LTE1T8XQ9G3CDthMLk+4m58lU3nff9H/Gh4VoQ=";
  };

  build-system = [ setuptools ];

  # remove when project is correctly tagged
  # currently released on pypi as 0.1.1, diff shows the only difference is
  # the version in setup.py
  # https://github.com/mecforlove/ecoji-py/issues/7
  postPatch = ''
    substituteInPlace setup.py --replace-fail "0.1.0" "0.1.1"
  '';

  pythonImportsCheck = [ "ecoji" ];
  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Encode and decode data as emojis, in Python";
    homepage = "https://github.com/mecforlove/ecoji-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
