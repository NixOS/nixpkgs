{
  lib,
  buildPythonPackage,
  fetchPypi,
  mercurial,
  tmpdirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "11.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jun1gZYZXv8nuJBnberK1bcTPTLCDgGGd543OeOEVOs=";
  };

  nativeCheckInputs = [
    mercurial
    tmpdirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck

    cat <<EOF >$HOME/.hgrc
    [extensions]
    evolve =
    topic =
    EOF

    # Shipped tests use the mercurial testing framework, and produce inconsistent results.
    # Do a quick smoke-test to see if things do what we expect.
    hg init $HOME/repo
    pushd $HOME/repo
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
    maintainers = with maintainers; [
      xavierzwirtz
      lukegb
    ];
    license = licenses.gpl2Plus;
  };
}
