{ lib, python, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pymetar";
  version = "1.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9a8caa21eff5367427da55a469ef396293ae4cc93797ab2f1a66a2924fbdc68";
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
    homepage = "http://www.schwarzvogel.de/software/pymetar.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erosennin ];
  };
}
