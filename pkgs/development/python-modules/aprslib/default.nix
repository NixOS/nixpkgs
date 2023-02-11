{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, mox3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aprslib";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "aprs-python";
    rev = "v${version}";
    hash = "sha256-2bYTnbJ8wF/smTpZ2tV+3ZRae7FpbNBtXoaR2Sc9Pek=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/rossengeorgiev/aprs-python/commit/c2a0f18ce028a4cced582567a73d57f0d03cd00f.patch";
      hash = "sha256-uxiLIagz1PIUUa6/qdBW15yhm/0QXqznVzZnzUVCWuQ=";
    })
  ];

  nativeCheckInputs = [
    mox3
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aprslib" ];

  meta = with lib; {
    description = "Module for accessing APRS-IS and parsing APRS packets";
    homepage = "https://github.com/rossengeorgiev/aprs-python";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
