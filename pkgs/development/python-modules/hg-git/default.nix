{ stdenv
, buildPythonPackage
, fetchPypi
, dulwich
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "0.8.12";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "56baea43bae1148d16d4faa50a7efb364e6dfbca7bc562aec908691327a80b8e";
  };

  propagatedBuildInputs = [ dulwich ];

  meta = with stdenv.lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = http://hg-git.github.com/;
    maintainers = with maintainers; [ koral ];
    license = stdenv.lib.licenses.gpl2;
  };

}
