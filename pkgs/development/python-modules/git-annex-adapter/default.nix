{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, substituteAll
, python, utillinux, pygit2, gitMinimal, git-annex, cacert
}:

buildPythonPackage rec {
  pname = "git-annex-adapter";
  version = "0.2.2";

  disabled = !isPy3k;

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "alpernebbi";
    repo = pname;
    rev = "v${version}";
    sha256 = "0666vqspgnvmfs6j3kifwyxr6zmxjs0wlwis7br4zcq0gk32zgdx";
  };

  patches = [
    (substituteAll {
      src = ./git-annex-path.patch;
      gitAnnex = "${git-annex}/bin/git-annex";
    })
  ];

  checkInputs = [
    gitMinimal
    utillinux # `rev` is needed in tests/test_process.py
  ];

  propagatedBuildInputs = [ pygit2 cacert ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';
  pythonImportsCheck = [ "git_annex_adapter" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/alpernebbi/git-annex-adapter";
    description = "Call git-annex commands from Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
