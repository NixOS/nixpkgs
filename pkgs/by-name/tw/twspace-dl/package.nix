{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg-headless,
}:

python3Packages.buildPythonApplication rec {
  pname = "twspace-dl";
  version = "2024.7.2.1";

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "twspace_dl";
    hash = "sha256-GLs+UGEOsdGcp/mEh+12Vs+XlY1goEql7UOAvVVi1pg=";
  };

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    mutagen
    requests
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}" ];

  pythonImportsCheck = [ "twspace_dl" ];

  meta = with lib; {
    description = "Python module to download twitter spaces";
    homepage = "https://github.com/HoloArchivists/twspace-dl";
    changelog = "https://github.com/HoloArchivists/twspace-dl/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "twspace_dl";
  };
}
