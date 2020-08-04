{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numba
, numpy
, pytestCheckHook
, rapidjson
}:

buildPythonPackage rec {
  pname = "awkward1";
  version = "0.2.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c868437aabb2e95efbc522c43d47cac42e1c61904c7ddbebf2f41c6b63bb9c6f";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ rapidjson ];
  propagatedBuildInputs = [ numpy ];

  dontUseCmakeConfigure = true;

  checkInputs = [ pytestCheckHook numba ];
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward-1.0";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
