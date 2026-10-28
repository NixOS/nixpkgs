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
    hash = "sha256-Yu3HcKuQdspyX1EVNfbRFfQq8T4iPNllJX3MdnYd4Ok=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Creates JUnit XML test result documents that can be read by tools such as Jenkins";
    homepage = "https://github.com/kyrus/python-junit-xml";
    maintainers = with lib.maintainers; [ multun ];
    license = lib.licenses.mit;
  };
}
