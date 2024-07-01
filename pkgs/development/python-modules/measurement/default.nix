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
  version = "3.2.2";
  format = "pyproject";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "coddingtonbear";
    repo = "python-measurement";
    rev = "refs/tags/${version}";
    hash = "sha256-ULId0W10FaAtSgVY5ctQL3FPETVr+oq6TKWd/W53viM=";
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

  meta = with lib; {
    description = "Use and manipulate unit-aware measurement objects in Python";
    homepage = "https://github.com/coddingtonbear/python-measurement";
    changelog = "https://github.com/coddingtonbear/python-measurement/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
