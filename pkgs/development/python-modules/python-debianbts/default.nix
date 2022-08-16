{ lib
, fetchFromGitHub
, buildPythonPackage
, pysimplesoap
}:

buildPythonPackage rec {
  pname = "python-debianbts";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "venthur";
    repo = "python-debianbts";
    rev = version;
    sha256 = "sha256-GQTxoEjmV6RHdVWDf1+C8u5VNTlAIBqNyGWK+sJh1Jk=";
  };

  postPatch = ''
    # Disable coverage and linting tests
    rm setup.cfg
  '';

  propagatedBuildInputs = [ pysimplesoap ];

  # Tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "debianbts" ];

  meta = with lib; {
    description = "Python interface to Debian's Bug Tracking System";
    homepage = "https://github.com/venthur/python-debianbts";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
