{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "crc";
  version = "4.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Nicoretti";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-h/RVMIJX+Lyted0FHNBcKY54EiirSclkBXCpAQSATq8=";
  };

  nativeBuildInputs = [ poetry-core ];

  pythonImportsCheck = [ "crc" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "test/bench" ];

  meta = with lib; {
    changelog = "https://github.com/Nicoretti/crc/releases/tag/${version}";
    description = "Python module for calculating and verifying predefined & custom CRC's";
    homepage = "https://nicoretti.github.io/crc/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jleightcap ];
  };
}
