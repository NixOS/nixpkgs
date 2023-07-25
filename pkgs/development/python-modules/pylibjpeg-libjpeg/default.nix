{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "pylibjpeg-libjpeg";
  version = "1.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-VmqeoMU8riLpWyC+yKqq56TkruxOie6pjbg+ozivpBk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

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
    changelog = "https://github.com/pydicom/pylibjpeg-libjpeg/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
