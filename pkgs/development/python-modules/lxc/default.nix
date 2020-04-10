{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pkgs
}:

buildPythonPackage {
  pname = "python-lxc-unstable";
  version = "2016-08-25";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "python2-lxc";
    rev = "0553f05d23b56b59bf3015fa5e45bfbfab9021ef";
    sha256 = "0p9kb20xvq91gx2wfs3vppb7vsp8kmd90i3q95l4nl1y4aismdn4";
  };

  buildInputs = [ pkgs.lxc ];

  meta = with stdenv.lib; {
    description = "Out of tree python 2.7 binding for liblxc";
    homepage = "https://github.com/lxc/python2-lxc";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ mic92 ];
  };

}
