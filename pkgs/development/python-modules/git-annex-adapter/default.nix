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

  # TODO: Remove for next version
  patches = [
    ./not-a-git-repo-testcase.patch
    (fetchpatch {
      url = "https://github.com/alpernebbi/git-annex-adapter/commit/9f64c4b99cae7b681820c6c7382e1e40489f4d1e.patch";
      sha256 = "0yh66gial6bx7kbl7s7lkzljnkpgvgr8yahqqcq9z76d0w752dir";
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
