{
  lib,
  buildPythonPackage,
  fetchPypi,
  matplotlib,
  numpy,
  python-dateutil,
  pytz,
  requests,
  retrying,
  scipy,
  six,
  tornado,
  tweepy,
  ws4py,
}:

buildPythonPackage rec {
  pname = "pyalgotrade";
  version = "0.20";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyAlgoTrade";
    inherit version;
    sha256 = "7927c87af202869155280a93ff6ee934bb5b46cdb1f20b70f7407337f8541cbd";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    python-dateutil
    pytz
    requests
    retrying
    scipy
    six
    tornado
    tweepy
    ws4py
  ];

  # no tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Python Algorithmic Trading";
    homepage = "http://gbeced.github.io/pyalgotrade/";
    license = licenses.asl20;
  };
}
