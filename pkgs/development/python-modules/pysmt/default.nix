{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysmt";
  version = "0.9.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pysmt";
    repo = "pysmt";
    rev = "v${version}";
    hash = "sha256-HmEdCJOF04h0z5UPpfYa07b78EEBj5KyVAk6aNRFPEo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysmt" ];

  meta = with lib; {
    description = "Python library for SMT formulae manipulation and solving";
    mainProgram = "pysmt-install";
    homepage = "https://github.com/pysmt/pysmt";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
