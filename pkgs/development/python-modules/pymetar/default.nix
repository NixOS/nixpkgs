{
  lib,
  python,
  buildPythonPackage,
  isPy3k,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pymetar";
  version = "1.4";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "48dbe6c4929961021cb61e49bb9e0605b54c4b61b9fb9ade51076705a08ecd54";
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
    mainProgram = "pymetar";
    homepage = "https://github.com/klausman/pymetar";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erosennin ];
  };
}
