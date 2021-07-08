{ lib, python, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pymetar";
  version = "1.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zhuXOZIIzh5p0CDOsiUNTqeXDoHFcf1BPg868fc7CIg=";
  };

  checkPhase = ''
    cd testing/smoketest
    tar xzf reports.tgz
    mkdir logs
    patchShebangs runtests.sh
    substituteInPlace runtests.sh --replace "break" "exit 1"  # fail properly
    export PYTHONPATH="$PYTHONPATH:$out/${python.sitePackages}"
    ./runtests.sh
  '';

  meta = with lib; {
    description = "A command-line tool to show the weather report by a given station ID";
    homepage = "https://github.com/klausman/pymetar";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erosennin ];
  };
}
