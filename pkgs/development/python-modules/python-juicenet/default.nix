{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "python-juicenet";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "jesserockz";
    repo = "python-juicenet";
    rev = "v${version}";
    sha256 = "04547pj51ds31yhyc7ng47v9giz16h2s3wgb6szc8ivhb5rclqz2";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyjuicenet" ];

  meta = with lib; {
    description = "Read and control Juicenet/Juicepoint/Juicebox based EVSE devices";
    homepage = "https://github.com/jesserockz/python-juicenet";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
