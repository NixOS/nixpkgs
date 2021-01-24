{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytestcov
, pytest_xdist
, pytest-django
, mock
, django
}:

buildPythonPackage rec {
  pname = "diskcache";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-diskcache";
    rev = "v${version}";
    sha256 = "0xwqw60dbn1x2294galcs08vm6ydcr677lr8slqz8a3ry6sgkhn9";
  };

  checkInputs = [
    pytestCheckHook
    pytestcov
    pytest_xdist
    pytest-django
    mock
  ];

  # Darwin sandbox causes most tests to fail.
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Disk and file backed persistent cache";
    homepage = "http://www.grantjenks.com/docs/diskcache/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
