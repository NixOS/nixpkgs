{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, requests
, beautifulsoup4
, colorama
}:

buildPythonPackage rec {
  pname = "hydra-check";
  version = "1.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-voSbpOPJUPjwzdMLVt2TC/FIi6LKk01PLd/GczOAUR8=";
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [
    colorama
    requests
    beautifulsoup4
  ];

  pythonImportsCheck = [ "hydra_check" ];

  meta = with lib; {
    description = "check hydra for the build status of a package";
    homepage = "https://github.com/nix-community/hydra-check";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu artturin ];
  };
}
