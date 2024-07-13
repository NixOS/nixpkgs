{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  pytestCheckHook,
  linux-gpib,
}:

buildPythonPackage rec {
  pname = "gpib-ctypes";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "gpib_ctypes";
    inherit version;
    hash = "sha256-c9l6TNmM4PtbvopnnFi5R1dQ9o3MI39BHHHPSGqfjCY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace gpib_ctypes/gpib/gpib.py \
      --replace "libgpib.so.0" "${linux-gpib}/lib/libgpib.so.0"
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  pythonImportsCheck = [ "gpib_ctypes.gpib" ];

  meta = with lib; {
    description = "Cross-platform Python bindings for the NI GPIB and linux-gpib C interfaces";
    homepage = "https://github.com/tivek/gpib_ctypes/";
    changelog = "https://github.com/tivek/gpib_ctypes/blob/${version}/HISTORY.rst";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fsagbuya ];
  };
}
