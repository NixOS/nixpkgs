{ lib
, buildPythonPackage
, fetchFromGitLab
, nose
}:

buildPythonPackage rec {
  pname = "pyxdg";
  version = "0.27";

  src =  fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = pname;
    rev = "rel-${version}";
    sha256 = "1dg826vrc7ifkk4lnf648h61cqfamaqmngkn9hgmxnf9gqmkbn0k";
  };

  # Tests failed (errors=4, failures=4) on NixOS
  doCheck = false;

  meta = with lib; {
    homepage = "http://freedesktop.org/wiki/Software/pyxdg";
    description = "Contains implementations of freedesktop.org standards";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
