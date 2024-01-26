{ lib
, buildPythonPackage
, fetchFromGitHub
  # Check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-constraint";
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-constraint";
    repo = "python-constraint";
    rev = version;
    sha256 = "1dv11406yxmmgkkhwzqicajbg2bmla5xfad7lv57zyahxz8jzz94";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "Constraint Solving Problem resolver for Python.";
    homepage = "https://labix.org/doc/constraint/";
    downloadPage = "https://github.com/python-constraint/python-constraint/releases";
    license = licenses.bsd2;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
