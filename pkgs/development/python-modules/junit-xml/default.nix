{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "junit-xml";
  version = "1.9";
  format = "setuptools";

  # Only a wheel on PyPI
  src = fetchFromGitHub {
    owner = "kyrus";
    repo = "python-junit-xml";
    # No tags...sigh
    rev = "856414648cbab3f64e69b856bc25cea8b9aa0377";
    sha256 = "1sg03mv7dk3x4mjxjg127vqjmx0ms7v3a5aibxrclxlhmdqcgvb2";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Creates JUnit XML test result documents that can be read by tools such as Jenkins";
    homepage = "https://github.com/kyrus/python-junit-xml";
    maintainers = with maintainers; [ multun ];
    license = licenses.mit;
  };
}
