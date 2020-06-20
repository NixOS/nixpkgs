{ lib
, buildPythonPackage
, fetchPypi
, pytest
, astropy
, astropy-helpers
, pillow
}:

buildPythonPackage rec {
  pname = "pyavm";
  version = "0.9.4";

  src = fetchPypi {
    pname = "PyAVM";
    inherit version;
    sha256 = "f298b864e5bc101ecbb0e46252e95e18a180ac28ba6ec362e63c12a7e914e386";
  };

  propagatedBuildInputs = [ astropy-helpers ];

  checkInputs = [ pytest astropy pillow ];

  checkPhase = "pytest";

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  meta = with lib; {
    description = "Simple pure-python AVM meta-data handling";
    homepage = "http://astrofrog.github.io/pyavm/";
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
