{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, future, pyusb, ipython, pygreat }:

buildPythonPackage rec {
  pname = "greatfet";
  version = "2021.2.1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "greatfet";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ZIZxK6P/LfYRAssME+5mJz5dTNLKo9217D7cAam+BgI=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ future pyusb ipython pygreat ];

  doCheck = false;

  preBuild = ''
    cd host
    echo "$version" > ../VERSION
  '';

  meta = {
    description = "Hardware hacking with the greatfet";
    homepage = "https://greatscottgadgets.com/greatfet";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mog ];
  };
}
