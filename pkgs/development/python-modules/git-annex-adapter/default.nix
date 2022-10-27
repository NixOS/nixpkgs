{ lib, buildPythonPackage, isPy3k, fetchFromGitHub, fetchpatch, substituteAll
, python, util-linux, pygit2, gitMinimal, git-annex, cacert
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
    # fix tests with recent versions of git-annex
    (fetchpatch {
      url = "https://github.com/alpernebbi/git-annex-adapter/commit/6c210d828e8a57b12c716339ad1bf15c31cd4a55.patch";
      sha256 = "17kp7pnm9svq9av4q7hfic95xa1w3z02dnr8nmg14sjck2rlmqsi";
    })
    (fetchpatch {
      url = "https://github.com/alpernebbi/git-annex-adapter/commit/b78a8f445f1fb5cf34b28512fc61898ef166b5a1.patch";
      hash = "sha256-BSVoOPWsgY1btvn68bco4yb90FAC7ay2kYZ+q9qDHHw=";
    })
    (substituteAll {
      src = ./git-annex-path.patch;
      gitAnnex = "${git-annex}/bin/git-annex";
    })
  ];

  checkInputs = [
    gitMinimal
    util-linux # `rev` is needed in tests/test_process.py
  ];

  propagatedBuildInputs = [ pygit2 cacert ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';
  pythonImportsCheck = [ "git_annex_adapter" ];

  meta = with lib; {
    homepage = "https://github.com/alpernebbi/git-annex-adapter";
    description = "Call git-annex commands from Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
