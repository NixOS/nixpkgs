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
    hash = "sha256-eSfIevIChpFVKAqT/27pNLtbRs2x8gtw90BzN/hUHL0=";
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
