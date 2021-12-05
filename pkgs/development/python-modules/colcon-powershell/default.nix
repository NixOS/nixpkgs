{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-powershell";
  version = "0.3.6";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-powershell.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "AOnW+mQLF32b5DrkYvuDIX6RxFB3ywbc+GeaWW/rehs=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-powershell";
    description = "An extension for colcon-core to provide PowerShell scripts.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
