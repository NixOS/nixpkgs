{ stdenv, python, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pymetar";
  version = "1.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y42l7mmp7jn4pzg66x3k57c6hqpxc22mgzgaqqpblkx2kzh42n9";
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

  meta = with stdenv.lib; {
    description = "A command-line tool to show the weather report by a given station ID";
    homepage = http://www.schwarzvogel.de/software/pymetar.html;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erosennin ];
  };
}
