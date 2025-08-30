{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Check inputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-constraint";
  version = "2.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-constraint";
    repo = "python-constraint";
    tag = version;
    sha256 = "sha256-Vi+dD/QmHfUrL0l5yTb7B1ILuXj3HYfT0QINdyfoqFo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Constraint Solving Problem resolver for Python";
    homepage = "https://labix.org/doc/constraint/";
    downloadPage = "https://github.com/python-constraint/python-constraint/releases";
    license = licenses.bsd2;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
