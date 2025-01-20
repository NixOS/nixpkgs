{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "ptable";
  version = "unstable-2019-06-14";
  pyproject = true;

  # https://github.com/kxxoling/PTable/issues/27
  src = fetchFromGitHub {
    owner = "kxxoling";
    repo = "PTable";
    rev = "bcfdb92811ae1f39e1065f31544710bf87d3bc21";
    sha256 = "1cj314rp6irlvr0a2c4xffsm2idsb0hzwr38vzz6z3kbhphcb63i";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/kxxoling/PTable";
    description = "Simple Python library designed to make it quick and easy to represent tabular data in visually appealing ASCII tables";
    mainProgram = "ptable";
    license = licenses.bsd3;
    maintainers = [ maintainers.mmahut ];
  };
}
