{ lib, buildPythonPackage, fetchFromGitHub
, click, pytest, glibcLocales
}:

buildPythonPackage rec {
  pname = "cligj";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "cligj";
    rev = version;
    sha256 = "sha256-0f9+I6ozX93Vn0l7+WR0mpddDZymJQ3+Krovt6co22Y=";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest tests
  '';

  meta = with lib; {
    description = "Click params for commmand line interfaces to GeoJSON";
    homepage = "https://github.com/mapbox/cligj";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
