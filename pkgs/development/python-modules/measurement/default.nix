{ lib, fetchFromGitHub, buildPythonPackage, isPy3k
, sympy, pytest, pytest-runner, sphinx, setuptools-scm }:

buildPythonPackage rec {
  pname = "measurement";
  version = "3.2.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "coddingtonbear";
    repo = "python-measurement";
    rev = "refs/tags/${version}";
    hash = "sha256-ULId0W10FaAtSgVY5ctQL3FPETVr+oq6TKWd/W53viM=";
  };

  postPatch = ''
    sed -i 's|use_scm_version=True|version="${version}"|' setup.py
  '';

  nativeCheckInputs = [ pytest pytest-runner ];
  nativeBuildInputs = [ sphinx setuptools-scm ];
  propagatedBuildInputs = [ sympy ];

  meta = with lib; {
    description = "Use and manipulate unit-aware measurement objects in Python";
    homepage = "https://github.com/coddingtonbear/python-measurement";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
