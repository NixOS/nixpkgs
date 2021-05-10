{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyjwt
, ratelimit
, pytz
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "pyflume";
  version = "0.6.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ChrisMandich";
    repo = "PyFlume";
    rev = "v${version}";
    sha256 = "1dm560hh6fl1waiwsq8m31apmvvwhc3y95bfdb7449bs8k96dmxq";
  };

  prePatch = ''
    substituteInPlace setup.py --replace 'pyjwt==2.0.1' 'pyjwt>=2.0.1'
    substituteInPlace setup.py --replace 'ratelimit==2.2.1' 'ratelimit>=2.2.1'
    substituteInPlace setup.py --replace 'pytz==2019.2' 'pytz>=2019.2'
    substituteInPlace setup.py --replace 'requests==2.24.0' 'requests>=2.24.0'
  '';

  propagatedBuildInputs = [
    pyjwt
    ratelimit
    pytz
    requests
  ];

  checkInputs = [
    requests-mock
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/ChrisMandich/PyFlume/issues/18
    substituteInPlace setup.py \
      --replace "pyjwt==2.0.1" "pyjwt>=2.0.1" \
      --replace "ratelimit==2.2.1" "ratelimit>=2.2.1" \
      --replace "pytz==2019.2" "pytz>=2019.2" \
      --replace "requests==2.24.0" "requests>=2.24.0"
  '';

  pythonImportsCheck = [ "pyflume" ];

  meta = with lib; {
    description = "Python module to work with Flume sensors";
    homepage = "https://github.com/ChrisMandich/PyFlume";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
