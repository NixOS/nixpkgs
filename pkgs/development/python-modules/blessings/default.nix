{ lib
, buildPythonPackage
, fetchPypi
, six
, nose
}:

buildPythonPackage rec {
  pname = "blessings";
  version = "1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d";
  };

  # 4 failing tests, 2to3
  doCheck = false;

  propagatedBuildInputs = [ six ];
  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://github.com/erikrose/blessings";
    description = "A thin, practical wrapper around terminal coloring, styling, and positioning";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };

}
