{ lib
, buildPythonPackage
, fetchPypi
, isl
, pytest
, cffi
, six
}:

buildPythonPackage rec {
  pname = "islpy";
  version = "2020.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee797e1284bffe897568f9cc1f063f1a6fac8d7b87596308b7467e9b870a90ef";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"pytest>=2\"," ""
  '';

  buildInputs = [ isl ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    cffi
    six
  ];

  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    description = "Python wrapper around isl, an integer set library";
    homepage = "https://github.com/inducer/islpy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
