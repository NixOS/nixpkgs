{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "mercantile";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = pname;
    rev = version;
    hash = "sha256-DiDXO2XnD3We6NhP81z7aIHzHrHDi/nkqy98OT9986w=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  meta = {
    description = "Spherical mercator tile and coordinate utilities";
    mainProgram = "mercantile";
    homepage = "https://github.com/mapbox/mercantile";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
