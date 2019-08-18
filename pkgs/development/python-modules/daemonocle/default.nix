{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, psutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "daemonocle";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "jnrbsn";
    repo = "daemonocle";
    rev = "v${version}";
    hash = "sha256-kDCbosXTIffuCzHcReXhiW4YPbxDW3OPnTbMC/EGJrM=";
  };

  propagatedBuildInputs = [ click psutil ];
  checkInputs = [ pytestCheckHook ];

  # One third of the tests fail on the sandbox with
  # "psutil.NoSuchProcess: no process found with pid 0".
  doCheck = false;
  disabledTests = [ "sudo" ];
  pythonImportsCheck = [ "daemonocle" ];

  meta = with lib; {
    description = "A Python library for creating super fancy Unix daemons";
    longDescription = ''
      daemonocle is a library for creating your own Unix-style daemons
      written in Python.  It solves many problems that other daemon
      libraries have and provides some really useful features you don't
      often see in other daemons.
    '';
    homepage = "https://github.com/jnrbsn/daemonocle";
    license = licenses.mit;
    maintainers = [ maintainers.AluisioASG ];
    platforms = platforms.unix;
  };
}
