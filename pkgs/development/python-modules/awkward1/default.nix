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
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87a85942613c9767a87e9c9ab9796b6a908f0eaf6a587f142a9fbb8c608564cb";
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
