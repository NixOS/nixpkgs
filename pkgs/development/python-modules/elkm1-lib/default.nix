{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "elkm1-lib";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "elkm1";
    rev = version;
    sha256 = "04xidix6l5d9rqfwp6cmj6wvais04nlvz5ynp0zwgyjp9sh2nhp6";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyserial-asyncio
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/gwww/elkm1/pull/45
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/gwww/elkm1/commit/807a17268498298908bf82af4933b158b37c8f32.patch";
      sha256 = "1539g8wsxppqj6dm6w81ps05frb8vrfaxahxn2cqs76zdhvly3p9";
    })
  ];

  pythonImportsCheck = [ "elkm1_lib" ];

  meta = with lib; {
    description = "Python module for interacting with ElkM1 alarm/automation panel";
    homepage = "https://github.com/gwww/elkm1";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
