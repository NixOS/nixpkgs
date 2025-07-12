{
  lib,
  buildPythonPackage,
  cython,
  numpy,
  libdynd,
  fetchpatch,
  cmake,
  fetchFromGitHub,
  pythonAtLeast,
}:

buildPythonPackage rec {
  version = "0.7.2";
  format = "setuptools";
  pname = "dynd";

  disabled = pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "libdynd";
    repo = "dynd-python";
    rev = "v${version}";
    sha256 = "19igd6ibf9araqhq9bxmzbzdz05vp089zxvddkiik3b5gb7l17nh";
  };

  patches = [
    # Fix numpy compatibility
    # https://github.com/libdynd/dynd-python/issues/746
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/numpy-compatibility.patch?h=python-dynd&id=e626acabd041069861311f314ac3dbe9e6fd24b7";
      sha256 = "sha256-oA/3G8CGeDhiYXbNX+G6o3QSb7rkKItuCDCbnK3Rt10=";
      name = "numpy-compatibility.patch";
    })
  ];

  # setup.py invokes git on build but we're fetching a tarball, so
  # can't retrieve git version. We hardcode:
  preConfigure = ''
    substituteInPlace setup.py --replace "ver = check_output(['git', 'describe', '--dirty'," "ver = '${version}'"
    substituteInPlace setup.py --replace "'--always', '--match', 'v*']).decode('ascii').strip('\n')" ""
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cython
    libdynd.dev
  ];

  propagatedBuildInputs = [
    libdynd
    numpy
  ];

  #  ModuleNotFoundError: No module named 'dynd.config'
  doCheck = false;

  pythonImportsCheck = [ "dynd" ];

  meta = with lib; {
    homepage = "http://libdynd.org";
    license = licenses.bsd2;
    description = "Python exposure of dynd";
    maintainers = with maintainers; [ teh ];
  };
}
