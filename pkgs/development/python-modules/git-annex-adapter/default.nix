{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, fetchpatch
, utillinux, pygit2, gitMinimal, git-annex
}:

buildPythonPackage rec {
  pname = "git-annex-adapter";
  version = "0.2.1";

  disabled = !isPy3k;

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "alpernebbi";
    repo = pname;
    rev = "v${version}";
    sha256 = "146q1jhcfc7f96ajkhjffskkljk2xzivs5ih5clb8qx0sh7mj097";
  };

  prePatch = ''
    substituteInPlace git_annex_adapter/process.py \
      --replace "'git', 'annex'" "'${git-annex}/bin/git-annex'" \
      --replace "'git-annex'" "'${git-annex}/bin/git-annex'"
  '';

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
