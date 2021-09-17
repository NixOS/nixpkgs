{ lib, buildPythonPackage, fetchPypi, packaging, pytest, setuptools-scm }:

buildPythonPackage rec {
  pname = "pytest-snapshot";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f99152df98587f883f37bb0315f082ab3e0c565f53413f1193bb0019b992c3ea";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ packaging ];

  # pypi does not contain tests and GitHub archive is not supported because setuptools-scm can't detect the version
  doCheck = false;
  pythonImportsCheck = [ "pytest_snapshot" ];

  meta = with lib; {
    description = "A plugin to enable snapshot testing with pytest";
    homepage = "https://github.com/joseph-roitman/pytest-snapshot/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
