{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, nvidia_x11
, pytestCheckHook
, pythonOlder
, substituteAll
, xmltodict
}:

buildPythonPackage rec {
  pname = "py3nvml";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "fbcotter";
    repo = pname;
    rev = version;
    sha256 = "sha256-k6ErpDpXg6eKSMLDHVgfl7M25nhERLX+w4ney371EGs=";
  };

  disabled = pythonOlder "3.5";

  patches = [
    (substituteAll {
      src = ./fix_shared_object_paths.patch;
      inherit nvidia_x11;
    })
  ];

  buildInputs = [ xmltodict ];

  checkInputs = [ pytestCheckHook numpy ];

  pythonImportsCheck = [ "py3nvml" ];

  meta = with lib; {
    description = "Python 3 compatible bindings to the NVIDIA Management Library";
    homepage = "https://github.com/fbcotter/py3nvml";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.bsd3;
  };
}
