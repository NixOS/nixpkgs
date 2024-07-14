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
    hash = "sha256-SNvmxJKZYQIcth5Ju54GBbVMS2G5+5reUQdnBaCOzVQ=";
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
    description = "Command-line tool to show the weather report by a given station ID";
    mainProgram = "pymetar";
    homepage = "https://github.com/klausman/pymetar";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erosennin ];
  };
}
