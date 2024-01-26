{ lib
, fetchFromGitHub
, python3Packages
, ddcutil
}:

python3Packages.buildPythonPackage rec {
  pname = "ddcci-plasmoid-backend";
  version = "0.1.10-kf6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "davidhi7";
    repo = "ddcci-plasmoid";
    rev = "refs/tags/v${version}";
    hash = "sha256-/UTIflcUyPHMQ2CQG0d2R0MaKuXYmlvnYnLNQ+nMWvw=";
  } + "/backend";

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
    poetry-core
  ];

  pythonRelaxDeps = [
    "fasteners"
  ];

  propagatedBuildInputs = with python3Packages; [
    fasteners
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ddcutil ]})
  '';

  meta = with lib; {
    description = "ddcci python backend for KDE plasma ddcci-plasmoid";
    homepage = "https://github.com/davidhi7/ddcci-plasmoid";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
