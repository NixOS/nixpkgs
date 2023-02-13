{ lib, buildPythonPackage, fetchFromGitHub
, click
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "mercantile";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = version;
    sha256 = "sha256-DiDXO2XnD3We6NhP81z7aIHzHrHDi/nkqy98OT9986w=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook hypothesis ];

  meta = with lib; {
    description = "Spherical mercator tile and coordinate utilities";
    homepage = "https://github.com/mapbox/mercantile";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
  };
}
