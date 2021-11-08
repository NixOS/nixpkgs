{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "Ousret";
    repo = "charset_normalizer";
    rev = version;
    sha256 = "0pv6yf5ialc82iimsjbq3gp5hh02pg4a7sdma48gd81h4h8qd627";
  };

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=charset_normalizer --cov-report=term-missing" ""
  '';

  pythonImportsCheck = [ "charset_normalizer" ];

  meta = with lib; {
    description = "Python module for encoding and language detection";
    homepage = "https://charset-normalizer.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
