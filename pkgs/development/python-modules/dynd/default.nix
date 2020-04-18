{ stdenv
, buildPythonPackage
, isPyPy
, isPy3k
, cython
, numpy
, pkgs
}:

buildPythonPackage rec {
  version = "0.7.2";
  pname = "dynd";
  disabled = isPyPy || !isPy3k; # tests fail on python2, 2018-04-11

  src = pkgs.fetchFromGitHub {
    owner = "libdynd";
    repo = "dynd-python";
    rev = "v${version}";
    sha256 = "19igd6ibf9araqhq9bxmzbzdz05vp089zxvddkiik3b5gb7l17nh";
  };

  # setup.py invokes git on build but we're fetching a tarball, so
  # can't retrieve git version. We hardcode:
  preConfigure = ''
    substituteInPlace setup.py --replace "ver = check_output(['git', 'describe', '--dirty'," "ver = '${version}'"
    substituteInPlace setup.py --replace "'--always', '--match', 'v*']).decode('ascii').strip('\n')" ""
  '';

  dontUseCmakeConfigure = true;

  # Python 3 works but has a broken import test that I couldn't
  # figure out.
  doCheck = !isPy3k;
  nativeBuildInputs = [ pkgs.cmake ];
  buildInputs = [ pkgs.libdynd.dev cython ];
  propagatedBuildInputs = [ numpy pkgs.libdynd ];

  meta = with stdenv.lib; {
    homepage = "http://libdynd.org";
    license = licenses.bsd2;
    description = "Python exposure of dynd";
    maintainers = with maintainers; [ teh ];
  };

}
