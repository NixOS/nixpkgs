{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "NoseJS";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qrhkd3sga56qf6k0sqyhwfcladwi05gl6aqmr0xriiq1sgva5dy";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests -v
  '';

  meta = with stdenv.lib; {
    homepage = https://pypi.org/project/NoseJS/;
    description = "A Nose plugin for integrating JavaScript tests into a Python test suite";
    license = licenses.free;
  };

}
