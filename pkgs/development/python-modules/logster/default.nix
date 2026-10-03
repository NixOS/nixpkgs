{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pygtail,
}:

buildPythonPackage rec {
  pname = "logster";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "etsy";
    repo = "logster";
    rev = version;
    hash = "sha256-uKCo77YdgRUqo0EZyGGxsYIfdjKxUGSZgERo1TwsTBk=";
  };

  propagatedBuildInputs = [ pygtail ];

  meta = {
    description = "Parses log files, generates metrics for Graphite and Ganglia";
    mainProgram = "logster";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/etsy/logster";
  };
}
