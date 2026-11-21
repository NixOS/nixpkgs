{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  numpy,
  typing-extensions,
  waveforms,
}:

buildPythonPackage rec {
  pname = "dwfpy";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mariusgreuel";
    repo = "dwfpy";
    rev = "v${version}";
    hash = "sha256-Mmrp69RH02Kd6gKJDeKyzYdeIzDxGkJvzEjgewNB/H8=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  buildInputs = [
    waveforms
  ];

  propagatedBuildInputs = [
    numpy
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace src/dwfpy/bindings.py \
      --replace "path = 'libdwf.so'" "path = '${waveforms}/lib/libdwf.so'"
  '';

  pythonImportsCheck = [ "dwfpy" ];

  meta = {
    description = "Python library for Digilent WaveForms devices";
    homepage = "https://github.com/mariusgreuel/dwfpy";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ phodina ];
  };
}
