{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "entry-points-txt";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-klFSt3Od7xYgenpMP4DBFoZeQanGrmtJxDm5qeZ1Psc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov=entry_points_txt --no-cov-on-fail" ""
  '';

  pythonImportsCheck = [
    "entry_points_txt"
  ];

  meta = with lib; {
    description = "Read & write entry_points.txt files";
    homepage = "https://github.com/jwodder/entry-points-txt";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ayazhafiz ];
  };
}
