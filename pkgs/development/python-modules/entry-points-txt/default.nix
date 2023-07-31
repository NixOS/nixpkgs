{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
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

  patches = [
    (fetchpatch {
      name = "relax-wheel-dependency-constraint.patch";
      url = "https://github.com/jwodder/entry-points-txt/commit/8f5235fe4d1c0d73d07e8f4ee8f6a76b29ca6434.patch";
      hash = "sha256-ssePCVlJuHPJpPyFET3FnnWRlslLnZbnfn42g52yVN4=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
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
