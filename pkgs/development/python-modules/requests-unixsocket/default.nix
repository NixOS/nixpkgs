{
stdenv, pkgs, python, wrapPython, buildPythonPackage, isPy3k,
urllib3, pytest, pytestpep8, waitress, requests, requests2
}:

buildPythonPackage rec {
  pname = "requests-unixsocket";
  name = "${pname}-${version}";
  version = "0.1.5";
  src = pkgs.fetchurl {
    url = "mirror://pypi/r/${pname}/${name}.tar.gz";
    sha256 = "0k19knydh0fzd7w12lfy18arl1ndwa0zln33vsb37yv1iw9w06x9";
  };
  doCheck = false;
  checkPhase = ''
    py.test
  '';
  meta = with stdenv.lib; {
    description = "Use requests to talk HTTP via a UNIX domain socket";
    homepage    = "https://github.com/msabramo/requests-unixsocket";
    license     = licenses.asl20;
    platforms   = platforms.linux;
  };
  propagatedBuildInputs = [ urllib3 pytest pytestpep8 waitress ] ++ (if isPy3k then [requests2] else [requests]);
  maintainer = with stdenv.lib.maintainers; [ psychomario ];
}
