{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cryptography
, freezegun
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "jwt";
  version = "1.3.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    inherit version;
    owner = "GehirnInc";
    repo = "python-jwt";
    rev = "v${version}";
    hash = "sha256-N1J8yBVX/O+92cRp+q2gA2cFsd+C7JjUR9jo0VGoINg=";
  };

  postPatch = ''
    # pytest-flake8 is incompatible flake8 6.0.0 and currently unmaintained
    substituteInPlace setup.cfg --replace "--flake8" ""
  '';

  propagatedBuildInputs = [
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
    freezegun
    pytest-cov
  ];

  pythonImportsCheck = [ "jwt" ];

  meta = with lib; {
    description = "JSON Web Token library for Python 3";
    homepage = "https://github.com/GehirnInc/python-jwt";
    license = licenses.asl20;
    maintainers = with maintainers; [ thornycrackers ];
  };
}
