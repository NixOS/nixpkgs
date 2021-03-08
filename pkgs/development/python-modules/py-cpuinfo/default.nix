{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, sysctl
}:

buildPythonPackage rec {
  pname = "py-cpuinfo";
  version = "7.0.0";

  src = fetchFromGitHub {
     owner = "workhorsy";
     repo = pname;
     rev = "v${version}";
     sha256 = "10qfaibyb2syiwiyv74l7d97vnmlk079qirgnw3ncklqjs0s3gbi";
  };

  # On Darwin sysctl is used to read CPU information.
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace cpuinfo/cpuinfo.py \
      --replace "len(_program_paths('sysctl')) > 0" "True" \
      --replace "_run_and_get_stdout(['sysctl'" "_run_and_get_stdout(['${sysctl}/bin/sysctl'"
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Get CPU info with pure Python 2 & 3";
    longDescription = ''
      Py-cpuinfo gets CPU info with pure Python and should work without any
      extra programs or libraries, beyond what your OS provides. It does not
      require any compilation (C/C++, assembly, etc.) to use and works with
      Python 2 and 3.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/workhorsy/py-cpuinfo/blob/v${version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
