{ lib
, fetchFromGitHub
, python3Packages
, ffmpeg
,
}:
python3Packages.buildPythonPackage rec {
  pname = "unsilence";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "lagmoellertim";
    repo = "unsilence";
    rev = version;
    hash = "sha256-M4Ek1JZwtr7vIg14aTa8h4otIZnPQfKNH4pZE4GpiBQ=";
  };

  nativeBuildInputs = with python3Packages; [
    rich
  ];

  propagatedBuildInputs = [
    python3Packages.rich
    python3Packages.setuptools # imports pkg_resources.parse_version
  ];

  makeWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  doCheck = false;
  pythonImportsCheck = [ "unsilence" ];

  pythonRelaxDeps = [ "rich" ];

  meta = with lib; {
    homepage = "https://github.com/lagmoellertim/unsilence";
    description = "Console Interface and Library to remove silent parts of a media file";
    mainProgram = "unsilence";
    license = licenses.mit;
    maintainers = with maintainers; [ esau79p ];
  };
}
