{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  chardet,
  pytestCheckHook,
  fetchpatch2,
}:

buildPythonPackage rec {
  pname = "pysrt";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "byroot";
    repo = "pysrt";
    rev = "v${version}";
    sha256 = "1f5hxyzlh5mdvvi52qapys9qcinffr6ghgivb6k4jxa92cbs3mfg";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/byroot/pysrt/commit/93f52f6d4f70f4e18dc71deeaae0ec1e9100a50f.patch?full_index=1";
      hash = "sha256-nikMPwj3OHvl6LunAfRk6ZbFUvVgPwF696Dt8R7BY4U=";
    })
  ];

  build-system = [ setuptools ];

  propagatedBuildInputs = [ chardet ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/byroot/pysrt";
    license = licenses.gpl3Only;
    description = "Python library used to edit or create SubRip files";
    mainProgram = "srt";
  };
}
