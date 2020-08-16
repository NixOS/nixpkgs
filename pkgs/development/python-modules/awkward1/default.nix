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
  version = "0.2.31";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b235ce4164c8472d4f0ac0ad4fe7980968659be9e955c44a922d04f93766e12";
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
