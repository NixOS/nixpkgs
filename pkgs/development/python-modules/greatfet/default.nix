{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  isPy3k,
  future,
  pyusb,
  ipython,
  pygreat,
}:

buildPythonPackage rec {
  pname = "greatfet";
  version = "2024.0.1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "greatfet";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-AKpaJZJTzMY3IQXLvVnLWh3IHeGp759z6tvaBl28BHQ=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    future
    pyusb
    ipython
    pygreat
  ];

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
