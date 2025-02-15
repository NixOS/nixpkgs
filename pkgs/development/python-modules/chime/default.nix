{
  alsa-utils,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  stdenv,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "chime";
  version = "0-unstable-2023-03-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MaxHalford";
    repo = "chime";
    rev = "083654b8886463acaff64f72224081a10260373b";
    hash = "sha256-t+ri/1JuczUFP7txRU8+5MaETMcsjLnuXbacJMzGf98=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = lib.optionals stdenv.isLinux [ alsa-utils ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Python sound notifications made easy";
    homepage = "https://github.com/MaxHalford/chime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
