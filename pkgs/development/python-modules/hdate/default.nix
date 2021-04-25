{ lib
, astral
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "hdate";
  version = "0.10.2";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "py-libhdate";
    repo = "py-libhdate";
    rev = "v${version}";
    sha256 = "07b0c7q8w6flj4q72v58d3wymsxfp5qz8z97qhhc2977mjx5fsxd";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    astral
    pytz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Version was not updated for the release
    (fetchpatch {
      name = "update-version.patch";
      url = "https://github.com/py-libhdate/py-libhdate/commit/b8186a891b29fed99def5ce0985ee0ae1e0dd77e.patch";
      sha256 = "1pmhgh57x9390ff5gyisng0l6b79sd6dxmf172hpk1gr03c3hv98";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace "^2020.5" ">=2020.5"
  '';

  pytestFlagsArray = [
    "tests"
  ];

  pythonImportsCheck = [ "hdate" ];

  meta = with lib; {
    description = "Python module for Jewish/Hebrew date and Zmanim";
    homepage = "https://github.com/py-libhdate/py-libhdate";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
