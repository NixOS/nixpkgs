{ stdenv
, buildPythonPackage
, fetchgit
, isPy3k
, simplejson
, unittest2
, nose
, pkgs
}:

buildPythonPackage rec {
  pname = "pycurl2";
  version = "7.20.0";
  disabled = isPy3k;

  src = fetchgit {
    url = "https://github.com/Lispython/pycurl.git";
    rev = "0f00109950b883d680bd85dc6e8a9c731a7d0d13";
    sha256 = "1qmw3cm93kxj94s71a8db9lwv2cxmr2wjv7kp1r8zildwdzhaw7j";
  };

  # error: (6, "Couldn't resolve host 'h.wrttn.me'")
  doCheck = false;

  buildInputs = [ pkgs.curl simplejson unittest2 nose ];

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/pycurl2;
    description = "A fork from original PycURL library that no maintained from 7.19.0";
    license = licenses.mit;
    platforms = platforms.linux;
  };

}
