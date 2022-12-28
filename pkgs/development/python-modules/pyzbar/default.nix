{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, pillow
, zbar
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyzbar";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "NaturalHistoryMuseum";
    repo = "pyzbar";
    rev = "v${version}";
    sha256 = "8IZQY6qB4r1SUPItDlTDnVQuPs0I38K3yJ6LiPJuwbU=";
  };

  propagatedBuildInputs = [ zbar pillow numpy ];

  checkInputs = [ pytestCheckHook ];

  # find_library doesn't return an absolute path
  # https://github.com/NixOS/nixpkgs/issues/7307
  postPatch = ''
    substituteInPlace pyzbar/zbar_library.py \
      --replace \
        "find_library('zbar')" \
        '"${lib.getLib zbar}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  disabledTests = [
    # find_library has been replaced by a hardcoded path
    # the test fails due to find_library not called
    "test_found_non_windows"
    "test_not_found_non_windows"
  ];

  pythonImportsCheck = [ "pyzbar" ];

  meta = with lib; {
    description = "Read one-dimensional barcodes and QR codes from Python using the zbar library.";
    homepage = "https://github.com/NaturalHistoryMuseum/pyzbar";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
