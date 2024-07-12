{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pymsteams";
  version = "0.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rveachkc";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-suPCAzjQp46+kKFiCtm65lxBbsn78Owq4dVmWCdhIpA=";
  };

  propagatedBuildInputs = [ requests ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pymsteams" ];

  meta = with lib; {
    description = "Python module to interact with Microsoft Teams";
    homepage = "https://github.com/rveachkc/pymsteams";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
