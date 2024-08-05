{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  mock,
  pexpect,
  pyserial,
  enum-compat,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pygatt";
  version = "4.0.5-unstable-2021-09-13";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "peplin";
    repo = "pygatt";
    rev = "70c68684ca5a2c5cbd8c4f6f039503fe9b848d24";
    hash = "sha256-u1kFw8JksWvMtAn1SqdcZeDs8kv5s0mdAj2+leXzMcc=";
  };

  patches = [
    # Migrate to pytest: https://github.com/peplin/pygatt/pull/351
    (fetchpatch2 {
      url = "https://github.com/peplin/pygatt/commit/467bd9620c73a17029c18b4beff8b1d38e46ec25.patch?full_index=1";
      hash = "sha256-FR9ZoqdrQSbXjUDqHljlcfxMitbr7CDpVEJ3XuCAUoo=";
    })
  ];

  pythonRemoveDeps = [ "coverage" ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"coverage == 5.5", ' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    pyserial
    enum-compat
  ];

  optional-dependencies.GATTTOOL = [ pexpect ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ optional-dependencies.GATTTOOL;

  pythonImportsCheck = [ "pygatt" ];

  meta = with lib; {
    description = "Python wrapper the BGAPI for accessing Bluetooth LE Devices";
    homepage = "https://github.com/peplin/pygatt";
    changelog = "https://github.com/peplin/pygatt/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ fab ];
  };
}
