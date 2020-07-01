{ buildPythonPackage
, fetchFromGitHub
, lib

# pythonPackages
, pytest
}:

buildPythonPackage rec {
  pname = "names";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "treyhunner";
    repo = pname;
    rev = version;
    sha256 = "0jfn11bl05k3qkqw0f4vi2i2lhllxdrbb1732qiisdy9fbvv8611";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Generate random names";
    homepage = "https://github.com/treyhunner/names";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
