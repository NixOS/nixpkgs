{ lib
, buildPythonPackage
, fetchPypi
, lxml
, cairosvg
, pyquery
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygal";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KSP5XS5RWTCqWplyGdzO+/PZK36vX8HJ/ruVsJk1/bI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace pytest-runner ""
  '';

  passthru.optional-dependencies = {
    lxml = [ lxml ];
    png = [ cairosvg ];
  };

  nativeCheckInputs = [
    pyquery
    pytestCheckHook
  ] ++ passthru.optional-dependencies.png;

  preCheck = ''
    # necessary on darwin to pass the testsuite
    export LANG=en_US.UTF-8
  '';

  meta = with lib; {
    description = "Sexy and simple python charting";
    homepage = "http://www.pygal.org";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
