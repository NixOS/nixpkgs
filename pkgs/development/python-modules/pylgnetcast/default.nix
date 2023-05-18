{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylgnetcast";
  version = "0.3.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Drafteed";
    repo = "python-lgnetcast";
    rev = "v${version}";
    sha256 = "0pmz52k2sfxj5x2wcwdjks2lqh1gb5zfrjgc6xij8jal4l9xd2dz";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pylgnetcast"
  ];

  meta = with lib; {
    description = "Python API client for the LG Smart TV running NetCast 3 or 4";
    homepage = "https://github.com/Drafteed/python-lgnetcast";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
