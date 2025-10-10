{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "base36";
  version = "0.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tonyseek";
    repo = "python-base36";
    rev = "v${version}";
    sha256 = "076nmk9s0zkmgs2zqzkaqij5cmzhf4mrhivbb9n6cvz52i1mppr5";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "[pytest]" "[tool:pytest]" \
      --replace "--pep8 --cov" ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test_base36.py" ];
  pythonImportsCheck = [ "base36" ];

  meta = with lib; {
    description = "Python implementation for the positional numeral system using 36 as the radix";
    homepage = "https://github.com/tonyseek/python-base36";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
