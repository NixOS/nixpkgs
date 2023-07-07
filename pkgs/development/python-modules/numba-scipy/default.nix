{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, scipy
, numba
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "numba-scipy";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cApTGH5GJZH/RbkRjKhL3injvixD5kvfaS49FjrPA2U=";
  };

  propagatedBuildInputs = [
    scipy
    numba
  ];

  postPatch = ''
    # https://github.com/numba/numba-scipy/pull/76
    substituteInPlace setup.py \
      --replace "scipy>=0.16,<=1.7.3" "scipy>=0.16"
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "numba_scipy"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Extends Numba to make it aware of SciPy";
    homepage = "https://github.com/numba/numba-scipy";
    changelog = "https://github.com/numba/numba-scipy/blob/master/CHANGE_LOG";
    license = licenses.bsd2;
    maintainers = with maintainers; [ Etjean ];
  };
}
