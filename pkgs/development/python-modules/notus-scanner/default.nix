{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, paho-mqtt
, poetry-core
, psutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "notus-scanner";
  version = "unstable-2021-09-05";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "049f9a5e6439e4e5113e3b8f30b25ead12d42a56";
    sha256 = "1fjxyn8wg2kf6xy3pbh7d7yn20dk529p03xpqyz7s40n9nsxhnza";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    paho-mqtt
    psutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/greenbone/notus-scanner/pull/31
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/greenbone/notus-scanner/commit/b52eea317faca30d411096044f9e5ea20b58da65.patch";
      sha256 = "0q11aslhva47kkpsnpayra7spa849j894vqv34pjqhcnlyipqw6d";
    })
  ];

  pythonImportsCheck = [ "notus.scanner" ];

  meta = with lib; {
    description = "Helper to create results from local security checks";
    homepage = "https://github.com/greenbone/notus-scanner";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
