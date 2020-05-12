{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, zope_interface
, cryptography
, application
, gmpy2
}:

buildPythonPackage rec {
  pname = "python-otr";
  version = "1.2.0";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = "release-${version}";
    sha256 = "0p3b1n8jlxwd65gbk2k5007fkhdyjwcvr4982s42hncivxvabzzy";
  };

  propagatedBuildInputs = [ zope_interface cryptography application gmpy2 ];

  meta = with stdenv.lib; {
    description = "A pure python implementation of OTR";
    homepage = "https://github.com/AGProjects/python-otr";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edwtjo ];
    # The package itself does not support python3, and its transitive
    # dependencies rely on namespace package support that does not work in
    # Nix's python2 infra. See #74619 for details.
    broken = true;
  };
}
