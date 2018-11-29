{ stdenv
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
  # https://bitbucket.org/durin42/hg-git/issues/264/unexpected-keyword-argument-createopts-hg
  patches =
    fetchpatch {
      url = "https://bitbucket.org/rsalmaso/hg-git/commits/a778506fd4be0bf1afa75755f6ee9260fa234a0f/raw";
      sha256 = "12r4qzbc5xcqwv0kvf8g4wjji7n45421zkbf6i75vyi4nl6n4j15";
    };

  meta = with stdenv.lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = http://hg-git.github.com/;
    maintainers = with maintainers; [ koral ];
    license = stdenv.lib.licenses.gpl2;
  };

}
