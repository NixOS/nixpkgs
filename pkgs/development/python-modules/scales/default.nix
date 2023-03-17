{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "scales";
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b6930f7d4bf115192290b44c757af5e254e3fcfcb75ff9a51f5c96a404e2753";
  };

  nativeCheckInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Stats for Python processes";
    homepage = "https://www.github.com/Cue/scales";
    license = licenses.asl20;
  };

}
