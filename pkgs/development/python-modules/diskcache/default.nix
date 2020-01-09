{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestcov
, pytest_xdist
, pytest-django
, mock
}:

buildPythonPackage rec {
  pname = "diskcache";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-diskcache";
    rev = "v${version}";
    sha256 = "0xy2vpk4hixb4gg871d9sx9wxdz8pi0pmnfdwg4bf8jqfjg022w8";
  };

  checkInputs = [
    pytest
    pytestcov
    pytest_xdist
    pytest-django
    mock
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Disk and file backed persistent cache";
    homepage = "http://www.grantjenks.com/docs/diskcache/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
