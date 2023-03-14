{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, setuptools
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

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    netaddr
  ];

  nativeCheckInputs = [
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
    (fetchpatch {
      name = "fix-collection-usage-2.patch";
      url = "https://github.com/arista-eosplus/pyeapi/commit/cc9c584e4a3167e3c1624cccb6bc0d9c9bcdbc1c.patch";
      sha256 = "sha256-EY0i1Skm1llEQAAzvrb2yelhhLBkqKAFJB5ObAIxAYo=";
      excludes = [
        ".github/workflows/ci.yml"
      ];
    })
    (fetchpatch {
      name = "fix-collection-usage-3.patch";
      url = "https://github.com/arista-eosplus/pyeapi/commit/dc35ab076687ea71665ae9524480b05a4e893909.patch";
      sha256 = "sha256-xPaYULCPTxiQGB9Im/qLet+XebW9wq+TAfrxcgQxcoE=";
    })
  ];

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
