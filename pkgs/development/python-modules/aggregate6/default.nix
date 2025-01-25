{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  py-radix-sr,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "aggregate6";
  version = "1.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "job";
    repo = "aggregate6";
    rev = version;
    hash = "sha256-tBo9LSmEu/0KPSeg17dlh7ngUvP9GyW6b01qqpr5Bx0=";
  };

  patches = [ ./0001-setup-remove-nose-coverage.patch ];

  # py-radix-sr is a fork, with fixes
  postPatch = ''
    substituteInPlace setup.py --replace-fail 'py-radix==0.10.0' 'py-radix-sr'
  '';

  build-system = [ setuptools ];

  dependencies = [ py-radix-sr ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "aggregate6" ];

  meta = {
    description = "IPv4 and IPv6 prefix aggregation tool";
    mainProgram = "aggregate6";
    homepage = "https://github.com/job/aggregate6";
    license = with lib.licenses; [ bsd2 ];
    maintainers = lib.teams.wdz.members ++ (with lib.maintainers; [ marcel ]);
  };
}
