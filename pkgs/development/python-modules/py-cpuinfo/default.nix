{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, sysctl
}:

buildPythonPackage rec {
  pname = "py-cpuinfo";
  version = "8.0.0";

  src = fetchFromGitHub {
     owner = "workhorsy";
     repo = pname;
     rev = "v${version}";
     sha256 = "sha256-Mgzj1HTasUNHeHMVwV6d+TeyVqnBNUwCJ1EC3kfovf8=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  # On Darwin sysctl is used to read CPU information.
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace cpuinfo/cpuinfo.py \
      --replace "len(_program_paths('sysctl')) > 0" "True" \
      --replace "_run_and_get_stdout(['sysctl'" "_run_and_get_stdout(['${sysctl}/bin/sysctl'"
  '';

  pythonImportsCheck = [ "cpuinfo" ];

  meta = with lib; {
    description = "Get CPU info with pure Python";
    longDescription = ''
      Py-cpuinfo gets CPU info with pure Python and should work without any
      extra programs or libraries, beyond what your OS provides. It does not
      require any compilation (C/C++, assembly, etc.) to use and works with
      Python.
    '';
    homepage = "https://github.com/workhorsy/py-cpuinfo";
    changelog = "https://github.com/workhorsy/py-cpuinfo/blob/v${version}/ChangeLog";
    license = licenses.mit;
    badPlatforms = [ "riscv32-linux" "riscv64-linux" ];
    maintainers = with maintainers; [ costrouc ];
  };
}
