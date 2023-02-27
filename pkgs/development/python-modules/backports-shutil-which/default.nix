{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  pname = "backports.shutil_which";
  version = "3.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test test
  '';

  meta = with lib; {
    description = "Backport of shutil.which from Python 3.3";
    homepage = "https://github.com/minrk/backports.shutil_which";
    license = licenses.psfl;
    maintainers = with maintainers; [ jluttine ];
  };
}
