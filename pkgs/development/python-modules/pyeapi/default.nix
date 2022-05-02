{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, mock
, netaddr
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyeapi";
  version = "0.8.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arista-eosplus";
    repo = pname;
    rev = "v${version}";
    sha256 = "13chya6wix5jb82k67gr44bjx35gcdwz80nsvpv0gvzs6shn4d7b";
  };

  propagatedBuildInputs = [
    netaddr
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  patches = [
    # Fix usage of collection, https://github.com/arista-eosplus/pyeapi/pull/223
    (fetchpatch {
      name = "fix-collection-usage.patch";
      url = "https://github.com/arista-eosplus/pyeapi/commit/81754f57eb095703cc474f527a0915360af76f68.patch";
      sha256 = "sha256-ZNBTPRNmXCFVJeRAJxzIHmCOXZiGwU6t4ekSupU3BX8=";
    })
  ];

  postPatch = ''
    # https://github.com/arista-eosplus/pyeapi/pull/223
    substituteInPlace test/unit/test_utils.py \
      --replace "collections.Iterable" "collections.abc.Iterable"
    substituteInPlace pyeapi/api/abstract.py \
      --replace "from collections" "from collections.abc"
  '';

  pytestFlagsArray = [
    "test/unit"
  ];

  pythonImportsCheck = [
    "pyeapi"
  ];

  meta = with lib; {
    description = "Client for Arista eAPI";
    homepage = "https://github.com/arista-eosplus/pyeapi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ astro ];
  };
}
