{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # pythonPackages
  pytest,
}:

buildPythonPackage rec {
  pname = "names";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "treyhunner";
    repo = "names";
    rev = version;
    sha256 = "0jfn11bl05k3qkqw0f4vi2i2lhllxdrbb1732qiisdy9fbvv8611";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Generate random names";
    mainProgram = "names";
    homepage = "https://github.com/treyhunner/names";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
