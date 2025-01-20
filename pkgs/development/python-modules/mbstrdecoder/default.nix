{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  chardet,
  pytestCheckHook,
  faker,
}:

buildPythonPackage rec {
  pname = "mbstrdecoder";
  version = "1.1.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-rJ3Q7/xYPO0jBuzhYm2aIhPar2tbJIxHnHR0y0HWtik=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ chardet ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ faker ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/mbstrdecoder";
    description = "Library for decoding multi-byte character strings";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
