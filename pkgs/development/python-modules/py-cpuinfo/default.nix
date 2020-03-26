{ lib
, fetchFromGitHub
, buildPythonPackage
, pytest
}:

buildPythonPackage rec {
  pname = "py-cpuinfo";
  version = "5.0.0";

  src = fetchFromGitHub {
     owner = "workhorsy";
     repo = pname;
     rev = "v${version}";
     sha256 = "0lxl9n6djaz5h1zrb2jca4qwl41c2plxy8chr7yhcxnzg0srddqi";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    pytest -k "not TestActual"
    runHook postCheck
  '';

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
