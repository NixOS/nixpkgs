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
  version = "2019.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "834b6b946f33d578d5c6b2f863dd93f7ecc4c0a2bf73407c96ef9f95b6b71bbf";
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
