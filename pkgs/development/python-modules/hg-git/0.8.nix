{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, isPy3k
, fetchpatch
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "0.8.12";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "13hbm0ki6s88r6p65ibvrbxnskinzdz0m9gsshb8s571p91ymfjn";
  };

  propagatedBuildInputs = [ dulwich ];

  # Needs patch to work with Mercurial 4.8
  # https://foss.heptapod.net/mercurial/hg-git/-/issues/264
  patches = [
    (fetchpatch {
      url = "https://foss.heptapod.net/mercurial/hg-git/-/commit/186b37af1ff61e8141e9eea5c75a03b3c82f1ab9.diff";
      sha256 = "sha256-KS6fUJOVzCYX/r5sdRXuFDKtlgxz80bGDFb71ISnRgc=";
    })
  ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Only;
  };
}
