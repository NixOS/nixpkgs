{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, click
, pytestcov
, isPy27
, mock
}:

buildPythonPackage rec {
  pname = "pytest-click";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "pytest-click";
    rev = version;
    sha256 = "1cd15anw8d4rq6qs03j6ag38199rqw7vp0w0w0fm41mvdzr0lwvz";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "mock==1.0.1" "mock"
  '';

  propagatedBuildInputs = [
    pytest
    click
  ];

  checkInputs = [ pytestcov ] ++ lib.optionals isPy27 [ mock ];

  meta = with lib; {
    description = "pytest plugin for click";
    homepage = https://github.com/Stranger6667/pytest-click;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
