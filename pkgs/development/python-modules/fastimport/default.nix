{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "fastimport";
  version = "0.9.14";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ac99dda4e7b0b3ae831507b6d0094802e6dd95891feafde8cc5c405b6c149ca";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "fastimport" ];

  meta = with lib; {
    homepage = "https://github.com/jelmer/python-fastimport";
    description = "VCS fastimport/fastexport parser";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Plus;
  };
}
