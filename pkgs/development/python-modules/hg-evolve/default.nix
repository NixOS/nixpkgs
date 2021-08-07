{ lib
, buildPythonPackage
, fetchPypi
, mercurial
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "10.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba819732409d39ddd4ff2fc507dc921408bf30535d2d78313637b29eeac98860";
  };

  checkInputs = [
    mercurial
  ];

  checkPhase = ''
    runHook preCheck

    export TESTTMP=$(mktemp -d)
    export HOME=$TESTTMP
    cat <<EOF >$HOME/.hgrc
    [extensions]
    evolve =
    topic =
    EOF

    # Shipped tests use the mercurial testing framework, and produce inconsistent results.
    # Do a quick smoke-test to see if things do what we expect.
    hg init $TESTTMP/repo
    pushd $TESTTMP/repo
    touch a
    hg add a
    hg commit -m "init a"
    hg topic something

    touch b
    hg add b
    hg commit -m "init b"

    echo hi > b
    hg amend

    hg obslog
    popd

    runHook postCheck
  '';

  meta = with lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz lukegb ];
    license = licenses.gpl2Plus;
  };
}
