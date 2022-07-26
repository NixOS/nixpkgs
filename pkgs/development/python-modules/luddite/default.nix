{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pytest-socket
, pytest-mock
}:

buildPythonPackage rec {
  pname = "luddite";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "jumptrading";
    repo = pname;
    rev = "v${version}";
    sha256 = "8/7uwO5HLhyXYt+T6VUO/O7TN9+FfRlT8y0r5+CJ/l4=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=luddite --cov-report=html --cov-report=term --no-cov-on-fail" ""
  '';

  propagatedBuildInputs = [ setuptools ];

  checkInputs = [ pytestCheckHook pytest-socket pytest-mock ];
  pythonImportsCheck = [ "luddite" ];

  meta = with lib; {
    description = "Checks for out-of-date package versions";
    homepage = "https://github.com/jumptrading/luddite";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
