{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "pylibjpeg-libjpeg";
  version = "1.3.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "refs/tags/v.${version}";
    hash = "sha256-fv3zX+P2DWMdxPKsvSPhPCV8cDX3tAMO/h5coMHBHN8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cython];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  doCheck = false;  # tests try to import 'libjpeg.data', which errors

  pythonImportsCheck = [
    "libjpeg"
  ];

  meta = with lib; {
    description = "A JPEG, JPEG-LS and JPEG XT plugin for pylibjpeg";
    homepage = "https://github.com/pydicom/pylibjpeg-libjpeg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
