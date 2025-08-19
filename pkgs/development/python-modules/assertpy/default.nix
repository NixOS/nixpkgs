{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "assertpy";
  version = "1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "assertpy";
    repo = "assertpy";
    rev = version;
    sha256 = "0hnfh45cmqyp7zasrllwf8gbq3mazqlhhk0sq1iqlh6fig0yfq2f";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "assertpy" ];

  meta = with lib; {
    description = "Simple assertion library for unit testing with a fluent API";
    homepage = "https://github.com/assertpy/assertpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
