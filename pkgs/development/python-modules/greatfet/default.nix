{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pyusb
, future
, tqdm
, cmsis-svd
, tabulate
, prompt-toolkit
, pygreat
, setuptools
, ipython
}:

buildPythonPackage rec {
  pname = "greatfet";
  version = "2021.2.1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "greatfet";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZIZxK6P/LfYRAssME+5mJz5dTNLKo9217D7cAam+BgI=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    pyusb
    future
    tqdm
    cmsis-svd
    tabulate
    prompt-toolkit
    pygreat
    setuptools
    ipython
  ];

  preBuild = ''
    cd host
    echo "$version" > ../VERSION
  '';

  doCheck = false;

  meta = {
    description = "Hardware hacking with the greatfet";
    homepage = "https://greatscottgadgets.com/greatfet";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mog ];
  };
}
