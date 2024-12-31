{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  isPy3k,
  flit-core,
  flit-scm,
  sympy,
  pytestCheckHook,
  sphinx,
}:

buildPythonPackage rec {
  pname = "measurement";
  version = "4.0a8";
  format = "pyproject";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "coddingtonbear";
    repo = "python-measurement";
    rev = "refs/tags/${version}";
    hash = "sha256-QxXxx9Jbx7ykQFaw/3S6ANPUmw3mhvSa4np6crsfVtE=";
  };

  nativeBuildInputs = [
    flit-core
    flit-scm
    sphinx
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=measurement" ""
  '';

  propagatedBuildInputs = [ sympy ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Use and manipulate unit-aware measurement objects in Python";
    homepage = "https://github.com/coddingtonbear/python-measurement";
    changelog = "https://github.com/coddingtonbear/python-measurement/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
