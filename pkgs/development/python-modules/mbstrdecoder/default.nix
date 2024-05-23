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
  version = "1.1.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GcAxXcCYC2XAE8xu/jdDxjPxkLJzbmvWZ3OgmcvQcmk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ chardet ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ faker ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/mbstrdecoder";
    description = "A library for decoding multi-byte character strings";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
