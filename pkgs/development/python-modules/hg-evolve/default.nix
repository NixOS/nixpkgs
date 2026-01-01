{
  lib,
  buildPythonPackage,
  fetchPypi,
  mercurial,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hg-evolve";
<<<<<<< HEAD
  version = "11.1.10";
=======
  version = "11.1.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "hg_evolve";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-ccFq7sASkOkFJ4Or5dhZpfKR0FdZAmbziDfK3FGcaYM=";
=======
    hash = "sha256-sypSfUqXQkmDSITJq/XHH82EGNIMvjgocc+3mLK+n0A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ mercurial ];

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

<<<<<<< HEAD
  meta = {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with lib.maintainers; [
      xavierzwirtz
      lukegb
    ];
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [
      xavierzwirtz
      lukegb
    ];
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
