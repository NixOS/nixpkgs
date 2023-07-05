{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "btest";
  version = "1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "btest";
    rev = "refs/tags/v${version}";
    hash = "sha256-QvK2MZTx+DD2u+h7dk0F5kInXGVp73ZTvG080WV2BVQ=";
  };

  # No tests available and no module to import
  doCheck = false;

  meta = with lib; {
    description = "A Generic Driver for Powerful System Tests";
    homepage = "https://github.com/zeek/btest";
    changelog = "https://github.com/zeek/btest/blob/${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
