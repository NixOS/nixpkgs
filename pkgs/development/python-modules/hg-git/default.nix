{ stdenv
, buildPythonPackage
, fetchPypi
, dulwich
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "0.8.11";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "08kw1sj3sq1q1571hwkc51w20ks9ysmlg93pcnmd6gr66bz02dyn";
  };

  propagatedBuildInputs = [ dulwich ];

  meta = with stdenv.lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = http://hg-git.github.com/;
    maintainers = with maintainers; [ koral ];
    license = stdenv.lib.licenses.gpl2;
  };

}
