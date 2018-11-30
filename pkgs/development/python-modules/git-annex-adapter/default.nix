{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, fetchpatch
, utillinux, pygit2, gitMinimal, git-annex
}:

buildPythonPackage rec {
  pname = "git-annex-adapter";
  version = "0.2.0";

  disabled = !isPy3k;

  # There is only a wheel on PyPI - build from source instead
  src = fetchFromGitHub {
    owner = "alpernebbi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sbgp4ivgw4m8nngrlb1f78xdnssh639c1khv4z98753w3sdsxdz";
  };

  prePatch = ''
    substituteInPlace git_annex_adapter/process.py \
      --replace "'git', 'annex'" "'${git-annex}/bin/git-annex'" \
      --replace "'git-annex'" "'${git-annex}/bin/git-annex'"
  '';

  patches = [
    # fixes the "not-a-git-repo" testcase where recent git versions expect a slightly different error.
    ./not-a-git-repo-testcase.patch

    # fixes the testcase which parses the output of `git-annex info` where several
    # new lines are displayed that broke the test.
    (fetchpatch {
      url = "https://github.com/Ma27/git-annex-adapter/commit/39cb6da69c1aec3d57ea9f68c2dea5113ae1b764.patch";
      sha256 = "0wyy2icqan3jpiw7dm50arfq3mgq4b5s3g91k82srap763r9hg5m";
    })

    # fixes the testcase which runs "git status" and complies with the
    # slightly altered output.
    (fetchpatch {
      url = "https://github.com/alpernebbi/git-annex-adapter/commit/9f64c4b99cae7b681820c6c7382e1e40489f4d1e.patch";
      sha256 = "0yh66gial6bx7kbl7s7lkzljnkpgvgr8yahqqcq9z76d0w752dir";
    })
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    # `rev` is part of utillinux on NixOS which is not available on `nixpks` for darwin:
    # https://logs.nix.ci/?key=nixos/nixpkgs.45061&attempt_id=271763ba-2ae7-4098-b469-b82b1d8edb9b
    (fetchpatch {
      url = "https://github.com/alpernebbi/git-annex-adapter/commit/0b60b4577528b309f6ac9d47b55a00dbda9850ea.patch";
      sha256 = "0z608hpmyzv1mm01dxr7d6bi1hc77h4yafghkynmv99ijgnm1qk7";
    })
  ];

  checkInputs = [
    utillinux # `rev` is needed in tests/test_process.py
  ];

  propagatedBuildInputs = [ pygit2 gitMinimal ];

  buildInputs = [ git-annex ];

  checkPhase = ''
    python -m unittest
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/alpernebbi/git-annex-adapter;
    description = "Call git-annex commands from Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ma27 ];
  };
}
