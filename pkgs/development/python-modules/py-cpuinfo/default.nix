{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  sysctl,
}:

buildPythonPackage rec {
  pname = "py-cpuinfo";
  version = "9.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "workhorsy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Q5u0guAqDVhf6bvJTzNvCpWbIzjxxAjE7s0OuXj9T4Q=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # On Darwin sysctl is used to read CPU information.
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace cpuinfo/cpuinfo.py \
      --replace "len(_program_paths('sysctl')) > 0" "True" \
      --replace "_run_and_get_stdout(['sysctl'" "_run_and_get_stdout(['${sysctl}/bin/sysctl'"
  '';

  pythonImportsCheck = [ "cpuinfo" ];

  meta = with lib; {
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
    license = licenses.mit;
    maintainers = [ ];
  };
}
