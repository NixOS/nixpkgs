{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "nosejs";
  version = "0.9.4";

  src = fetchPypi {
    pname = "NoseJS";
    inherit version;
    sha256 = "0qrhkd3sga56qf6k0sqyhwfcladwi05gl6aqmr0xriiq1sgva5dy";
  };

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests -v
  '';

  meta = with lib; {
    homepage = "https://pypi.org/project/NoseJS/";
    description = "A Nose plugin for integrating JavaScript tests into a Python test suite";
    license = licenses.free;
  };

}
