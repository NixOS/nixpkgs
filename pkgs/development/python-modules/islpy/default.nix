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
  version = "2018.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be422a53b576210a0bb9775866abb6580b1e568222fc3e4e39d9e82f6d1d7253";
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
    homepage = https://github.com/inducer/islpy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
