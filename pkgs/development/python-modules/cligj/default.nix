{ stdenv, buildPythonPackage, fetchFromGitHub
, click, pytest, glibcLocales
}:

buildPythonPackage rec {
  pname = "cligj";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "cligj";
    rev = version;
    sha256 = "0fclxagxv23v75yiypb29a8sja23dakhvmx3blmxyhg2sci92sx8";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest tests
  '';

  meta = with stdenv.lib; {
    description = "Click params for commmand line interfaces to GeoJSON";
    homepage = https://github.com/mapbox/cligj;
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
