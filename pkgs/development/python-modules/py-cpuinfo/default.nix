{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  sysctl,
}:

buildPythonPackage rec {
  pname = "py-cpuinfo";
  version = "9.0.0-unstable-2022-11-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "workhorsy";
    repo = "py-cpuinfo";
    rev = "f3f0fec58335b9699b9b294267c15f516045b1fe";
    hash = "sha256-oORoJNnbKLNmdqoyVhW6WbI4p2G7oMDhtTqeDvaDiGQ=";
  };

  # On Darwin sysctl is used to read CPU information.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cpuinfo/cpuinfo.py \
      --replace "len(_program_paths('sysctl')) > 0" "True" \
      --replace "_run_and_get_stdout(['sysctl'" "_run_and_get_stdout(['${sysctl}/bin/sysctl'"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cpuinfo" ];

  meta = {
    description = "Get CPU info with pure Python";
    mainProgram = "cpuinfo";
    longDescription = ''
      Py-cpuinfo gets CPU info with pure Python and should work without any
      extra programs or libraries, beyond what your OS provides. It does not
      require any compilation (C/C++, assembly, etc.) to use and works with
      Python.
    '';
    homepage = "https://github.com/workhorsy/py-cpuinfo";
    changelog = "https://github.com/workhorsy/py-cpuinfo/blob/v${version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
