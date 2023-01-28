{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pythonegardia";
  version = "1.0.51";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jeroenterheerdt";
    repo = "python-egardia";
    rev = "v${version}";
    sha256 = "7HindS++jcV3GRn/SKoTMpVOchOnLojy/TY0HZjtyD8=";
  };

  propagatedBuildInputs = [
    requests
  ];

  patches = [
    # Adjust search path, https://github.com/jeroenterheerdt/python-egardia/pull/33
    (fetchpatch {
      name = "search-path.patch";
      url = "https://github.com/jeroenterheerdt/python-egardia/commit/6b7bf5b7b2211e3557e0f438586b9d03b9bae440.patch";
      sha256 = "wUSfmF0SrKCITQJJsHgkGgPZFouaB/zbVqupK6fARHY=";
    })
  ];

  # Project has no tests, only two test file for manual interaction
  doCheck = false;

  pythonImportsCheck = [
    "pythonegardia"
  ];

  meta = with lib; {
    description = "Python interface with Egardia/Woonveilig alarms";
    homepage = "https://github.com/jeroenterheerdt/python-egardia";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
