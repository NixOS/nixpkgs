{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, coverage
, isPy27
}:

buildPythonPackage rec {
  pname = "aiounittest";
  version = "1.3.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kwarunek";
    repo = pname;
    rev = version;
    sha256 = "0mlic2q49cb0vv62mixy4i4x8c91qb6jlji7khiamcxcg676nasl";
  };

  checkInputs = [
    nose
    coverage
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Test asyncio code more easily";
    homepage = https://github.com/kwarunek/aiounittest;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
