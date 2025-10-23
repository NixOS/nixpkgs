{
  lib,
  stdenv,
  buildPythonPackage,
  click,
  cython,
  distutils,
  fetchFromGitHub,
  gcc,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "primer3";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "libnano";
    repo = "primer3-py";
    tag = "v${version}";
    hash = "sha256-GrVYYjS/+LZScZETfk7YcSy2yrWc3SPumXvyQeEpFUg=";
  };

  build-system = [
    distutils
    setuptools
  ];

  nativeBuildInputs = [ cython ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ gcc ];

  nativeCheckInputs = [
    click
    pytestCheckHook
  ];
  # We are not sure why exactly this is need. It seems `pytestCheckHook`
  # doesn't find extension modules installed in $out/${python.sitePackages},
  # and the tests rely upon them. This was initially reported upstream at
  # https://github.com/libnano/primer3-py/issues/120 and we investigate this
  # downstream at: https://github.com/NixOS/nixpkgs/issues/255262.
  preCheck = ''
    python setup.py build_ext --inplace
  '';

  pythonImportsCheck = [ "primer3" ];

  meta = with lib; {
    description = "Oligo analysis and primer design";
    homepage = "https://github.com/libnano/primer3-py";
    changelog = "https://github.com/libnano/primer3-py/blob/${src.tag}/CHANGES";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
