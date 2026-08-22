{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "pypilot-data";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "pypilot";
    repo = "pypilot_data";
    rev = "1df915910725d586cb846cdca42ee445c2709ff6";
    hash = "sha256-UN4QuiLdRKXzOhYZKvRCeWr/BqEr8EdvYQ+5L1Z4L+M=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  pythonImportsCheck = [ "pypilot_data" ];

  meta = {
    description = "Shared data files for the pypilot autopilot";
    homepage = "https://github.com/pypilot/pypilot_data";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.darkone ];
    platforms = lib.platforms.linux;
  };
}
