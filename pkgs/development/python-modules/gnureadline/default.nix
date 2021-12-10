{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  version = "8.0.0";
  pname = "gnureadline";
  disabled = isPyPy;

  src = fetchFromGitHub {
     owner = "ludwigschwardt";
     repo = "python-gnureadline";
     rev = "v8.0.0";
     sha256 = "130ph0l2wapax33wdkgdw0lla3agigmwdp3v73w7a7r3sn019qm5";
  };

  buildInputs = [ pkgs.ncurses ];
  patchPhase = ''
    substituteInPlace setup.py --replace "/bin/bash" "${pkgs.bash}/bin/bash"
  '';

  meta = with lib; {
    description = "The standard Python readline extension statically linked against the GNU readline library";
    homepage = "https://github.com/ludwigschwardt/python-gnureadline";
    license = licenses.gpl3;
  };

}
